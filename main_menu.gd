extends Control


func _on_start_pressed() -> void:
	# Cargar y mostrar controles
	var controles = load("res://controles.tscn").instantiate()
	add_child(controles)
	# Esperar 3 segundos y luego continuar
	await get_tree().create_timer(2.0).timeout
	controles.queue_free()
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
