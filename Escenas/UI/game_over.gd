# game_over.gd
extends Node2D
@onready var control = $Control
@onready var center_container = $Control/CenterContainer
func _ready():
	# Que esta escena siga funcionando aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Asignar tamaño directo (las anclas no funcionan bien porque el padre es Node2D, no Control)
	var vp_size = get_viewport_rect().size
	control.position = Vector2.ZERO
	control.size = vp_size
	center_container.position = Vector2.ZERO
	center_container.size = vp_size
	
	# Pausamos el juego
	get_tree().paused = true
func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/Menu/MenuPrincipal.tscn")
