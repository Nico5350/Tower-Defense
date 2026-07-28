extends Node2D
@onready var path = $Path2D
@onready var enemies_container = $Enemies
@onready var towers_container = $Towers
@onready var label_vida = $UI/PanelMenu/FilaHUD/VBoxVida/LabelVida
@onready var label_oleada = $UI/PanelMenu/FilaHUD/VBoxVida/LabelOleada
@onready var slot_torre1 = $UI/PanelMenu/FilaHUD/CentroTorres/HBoxContainerTorres/SlotTorre1
@onready var slot_torre2 = $UI/PanelMenu/FilaHUD/CentroTorres/HBoxContainerTorres/SlotTorre2
@onready var grilla_visual = $GrillaVisual
@onready var panel_pausa = $UI/PanelPausa
var GameOverScene = preload("res://Escenas/UI/GameOver.tscn")
var VictoriaScene = preload("res://Escenas/UI/Victoria.tscn")
var EnemyScene1 = preload("res://Escenas/Enemigos/Enemigo1.tscn")
var EnemyScene2 = preload("res://Escenas/Enemigos/Enemigo2.tscn")
var TowerScene1 = preload("res://Escenas/Torres/Torre1.tscn")
var TowerScene2 = preload("res://Escenas/Torres/Torre2.tscn")
var OleadasScene = preload("res://Escenas/Oleadas/Oleadas.tscn")
var sistema_oleadas: Node
var torre_seleccionada: PackedScene = null
# Grilla: cada casilla mide 24px, cada torre ocupa un bloque de 2x2 casillas (48x48)
const TILE_SIZE = 24
const TORRE_TILES = 2
var casillas_ocupadas: Dictionary = {}
func _ready():
	var base = get_tree().get_first_node_in_group("base")
	if base:
		base.vida_cambiada.connect(_on_vida_cambiada)
		base.base_destruida.connect(_on_base_destruida)
	
	sistema_oleadas = OleadasScene.instantiate()
	add_child(sistema_oleadas)
	sistema_oleadas.inicializar(path, enemies_container, {"tipo1": EnemyScene1, "tipo2": EnemyScene2})
	sistema_oleadas.oleada_iniciada.connect(_on_oleada_iniciada)
	sistema_oleadas.oleada_completada.connect(_on_oleada_completada)
	sistema_oleadas.iniciar_oleada()
	
	slot_torre1.button_down.connect(func(): seleccionar_torre(TowerScene1))
	slot_torre2.button_down.connect(func(): seleccionar_torre(TowerScene2))
func seleccionar_torre(escena: PackedScene):
	torre_seleccionada = escena
	print("Torre seleccionada: ", escena.resource_path)
	grilla_visual.queue_redraw()
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			get_tree().paused = true
			panel_pausa.visible = true
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if torre_seleccionada == null:
				return
			colocar_torre(event.position)
func colocar_torre(pos: Vector2):
	# Determinar la casilla base (esquina superior izquierda del bloque 2x2)
	var tile_x = int(floor(pos.x / TILE_SIZE))
	var tile_y = int(floor(pos.y / TILE_SIZE))
	# Alinear al bloque de TORRE_TILES para que todos los bloques queden parejos en el mapa
	tile_x = int(floor(float(tile_x) / TORRE_TILES)) * TORRE_TILES
	tile_y = int(floor(float(tile_y) / TORRE_TILES)) * TORRE_TILES
	
	# Verificar que las 4 casillas del bloque estén libres
	for dx in range(TORRE_TILES):
		for dy in range(TORRE_TILES):
			var clave = Vector2i(tile_x + dx, tile_y + dy)
			if casillas_ocupadas.has(clave):
				print("Ya hay una torre aquí")
				return
	
	# Marcar las 4 casillas como ocupadas
	for dx in range(TORRE_TILES):
		for dy in range(TORRE_TILES):
			var clave = Vector2i(tile_x + dx, tile_y + dy)
			casillas_ocupadas[clave] = true
	
	# Centrar la torre dentro del bloque de 2x2 casillas
	var bloque_size = TILE_SIZE * TORRE_TILES
	var torre_pos = Vector2(
		tile_x * TILE_SIZE + bloque_size / 2.0,
		tile_y * TILE_SIZE + bloque_size / 2.0
	)
	
	var torre = torre_seleccionada.instantiate()
	towers_container.add_child(torre)
	torre.position = torre_pos
	torre_seleccionada = null
	grilla_visual.queue_redraw()
func _on_oleada_iniciada(numero):
	label_oleada.text = "Oleada: " + str(numero)
func _on_oleada_completada(numero):
	await get_tree().create_timer(3.0).timeout
	if numero >= sistema_oleadas.lista_oleadas.size():
		# Era la última oleada
		var victoria = VictoriaScene.instantiate()
		get_tree().root.add_child(victoria)
		return
	label_oleada.text = "Oleada: " + str(numero + 1)
	sistema_oleadas.iniciar_oleada()
func _on_vida_cambiada(nueva_vida):
	label_vida.text = "Vida: " + str(nueva_vida)
func _on_base_destruida():
	label_vida.text = "Vida: 0"
	var game_over = GameOverScene.instantiate()
	get_tree().root.add_child(game_over)
