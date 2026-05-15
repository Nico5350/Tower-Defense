extends Node2D

@onready var path = $Path2D
@onready var enemies_container = $Enemies
@onready var towers_container = $Towers
@onready var label_vida = $UI/LabelVida
@onready var label_oleada = $UI/LabelOleada
@onready var tilemap = $TileMapLayer

var EnemyScene = preload("res://Escenas/Enemigos/Enemigo1.tscn")
var TowerScene = preload("res://Escenas/Torres/Torre1.tscn")
var sistema_oleadas: Node

# Tamaño del tile
const TILE_SIZE = 16

func _ready():
	var base = get_tree().get_first_node_in_group("base")
	if base:
		base.vida_cambiada.connect(_on_vida_cambiada)
		base.base_destruida.connect(_on_base_destruida)
	
	sistema_oleadas = load("res://Escenas/Scripts/Oleadas.gd").new()
	add_child(sistema_oleadas)
	sistema_oleadas.inicializar(path, enemies_container, EnemyScene)
	sistema_oleadas.oleada_iniciada.connect(_on_oleada_iniciada)
	sistema_oleadas.oleada_completada.connect(_on_oleada_completada)
	sistema_oleadas.iniciar_oleada()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Verificar que no se hizo clic sobre una torre existente
			for torre in towers_container.get_children():
				if torre.global_position.distance_to(event.position) <= 16:
					return
			colocar_torre(event.position)

func colocar_torre(pos: Vector2):
	# Snapear al grid de 16x16
	var tile_pos = Vector2(
		floor(pos.x / TILE_SIZE) * TILE_SIZE,
		floor(pos.y / TILE_SIZE) * TILE_SIZE
	)
	
	# Convertir posición del mundo a coordenadas del tile
	var tile_coords = tilemap.local_to_map(tile_pos)
	
	# Obtener el tile en esa posición
	var tile_data = tilemap.get_cell_atlas_coords(tile_coords)
	
	# Solo permitir colocar en pasto (0,0)
	if tile_data != Vector2i(0, 0):
		print("No se puede colocar torre aquí")
		return
	
	# Verificar que no haya ya una torre ahí
	for torre in towers_container.get_children():
		if torre.position == tile_pos:
			print("Ya hay una torre aquí")
			return
	
	var torre = TowerScene.instantiate()
	towers_container.add_child(torre)
	torre.position = tile_pos
	print("Torre colocada en: ", tile_pos)

func _on_oleada_iniciada(numero):
	label_oleada.text = "Oleada: " + str(numero)

func _on_oleada_completada(numero):
	await get_tree().create_timer(3.0).timeout
	label_oleada.text = "Oleada: " + str(numero + 1)
	sistema_oleadas.iniciar_oleada()

func _on_vida_cambiada(nueva_vida):
	label_vida.text = "Vida: " + str(nueva_vida)

func _on_base_destruida():
	label_vida.text = "Vida: 0"
	print("GAME OVER")
