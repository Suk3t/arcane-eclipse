extends Control




func _on_start_pressed() -> void:
	# Cargar y mostrar controles
	var controles = load("res://controles.tscn").instantiate()
	add_child(controles)
	# Esperar 3 segundos y luego continuar
	await get_tree().create_timer(2.0).timeout
	controles.queue_free()
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")



func _on_back_pressed() -> void:
	$VBoxContainer.visible = true
	$SettingsMenu.visible = false

func _on_settings_pressed() -> void:
	$VBoxContainer.visible = false
	$SettingsMenu.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
