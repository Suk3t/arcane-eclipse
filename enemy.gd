extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var max_health := 3
var current_health := max_health
var is_alive = true



func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func _ready():
	add_to_group("enemies")

func enemy():
	pass


func die() -> void:
	if !is_alive:
		return
	is_alive = false
	$enemy_hitbox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play("dead")
	queue_free()
	
	
func take_damage(amount: int) -> void:
	if !is_alive:
		return
	current_health -= amount
	print("Enemigo recibió daño. Vida actual:", current_health)
	if current_health <= 0:
		die()


func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area is Bullet and is_alive:
		take_damage(area.damage)
		area.queue_free()
