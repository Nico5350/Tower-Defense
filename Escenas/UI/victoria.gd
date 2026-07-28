# victoria.gd
extends Node2D
@onready var control = $Control
@onready var center_container = $Control/CenterContainer
func _ready():
	# Que esta escena siga funcionando aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Forzar que el Control ocupe toda la pantalla
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Forzar que el CenterContainer también ocupe todo el Control, para que centre bien su contenido
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	print("DEBUG Control size: ", control.size, " position: ", control.position)
	print("DEBUG CenterContainer size: ", center_container.size, " position: ", center_container.position)
	print("DEBUG Viewport size: ", get_viewport_rect().size)
	# Pausamos el juego (después de asegurar que esta escena no se pause a sí misma)
	get_tree().paused = true
func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/Menu/MenuPrincipal.tscn")
