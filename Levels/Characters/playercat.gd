extends CharacterBody2D

var fireball_scene = preload("res://scene/bullet.tscn")

var enemy_inattack_range = false
var enemy_attack_cooldown = true
@export var max_health: int = 5
var current_health: int = max_health
var player_alive = true

var can_take_damage: bool = true
@export var damage_cooldown: float = 1.0  # segundos

@export var move_speed : float = 300
@export var starting_direction : Vector2 = Vector2(0,1)


@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameter(starting_direction)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot_fireball()


func shoot_fireball():
	var fireball = fireball_scene.instantiate()
	get_tree().current_scene.add_child(fireball)
	
	fireball.global_position = global_position
	
	var mouse_pos = get_global_mouse_position()
	fireball.direction = (mouse_pos - global_position).normalized()
	print("Disparando hacia:", (get_global_mouse_position() - global_position).normalized())

	


func _physics_process(_delta:):
	
	var input_direction = Vector2(
	Input.get_action_strength("right") - Input.get_action_strength("left"),
	Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	enemy_attack()
	
	update_animation_parameter(input_direction)
	
	
	velocity = input_direction * move_speed
	move_and_slide()
	
	pick_new_state()
	
func update_animation_parameter(move_input : Vector2):
	
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position",move_input)
		animation_tree.set("parameters/idle/blend_position",move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("walk",false)
	else:
		state_machine.travel("idle",false)


func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemy_inattack_range = false

		
func enemy_attack():
	if enemy_inattack_range and player != null:
		take_damage(1)
	
	
func take_damage(amount: int):
	if not can_take_damage:
		return
	
	current_health -= amount
	print("Vida actual:", current_health)
	
	can_take_damage = false
	await get_tree().create_timer(damage_cooldown).timeout
	can_take_damage = true

	if current_health <= 0:
		die()




func die():
	print("¡Jugador muerto!")
