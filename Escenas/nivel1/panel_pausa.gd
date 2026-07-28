extends Control
func _on_reanudar_pressed():
	get_tree().paused = false
	visible = false
func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/Menu/MenuPrincipal.tscn")
func _on_salir_pressed():
	get_tree().quit()
