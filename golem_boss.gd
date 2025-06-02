extends CharacterBody2D

@onready var player = get_parent().find_child("Playercat")
@onready var sprite = $Sprite2D
@onready var progress_bar = $UI/ProgressBar

var direction: Vector2
var is_alive = true
var max_health := 100

var health := max_health:
	set(value):
		health = clamp(value, 0, max_health)
		progress_bar.value = health
		if health <= 0 and is_alive:
			is_alive = false
			progress_bar.visible = false
			print("boss murio")
			find_child("FiniteStateMachine").change_state("Death")

func _ready() -> void:
	set_physics_process(false)
	progress_bar.max_value = max_health
	progress_bar.value = health

func _process(delta: float) -> void:
	direction = player.position - position
	sprite.flip_h = direction.x < 0

func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * 20
	move_and_collide(velocity * delta)

func take_damage(amount: int) -> void:
	if !is_alive:
		return
	health -= amount
	print("Enemigo recibió daño. Vida actual:", health)

func _on_boss_hitbox_area_entered(area: Area2D) -> void:
	if area is Bullet and is_alive:
		take_damage(3)
		area.queue_free()
