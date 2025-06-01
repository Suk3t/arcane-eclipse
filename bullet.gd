extends Area2D


@export var speed := 200.0
var direction := Vector2.ZERO
var origin = global_position


func _process(delta):
	position += direction * speed * delta
	if position.distance_to(origin) > 1000:  # o el rango que desees
		queue_free()
