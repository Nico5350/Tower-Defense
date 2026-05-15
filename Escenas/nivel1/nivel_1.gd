extends Node2D

@onready var path = $Path2D
@onready var enemies_container = $Enemies
@onready var label_vida = $UI/LabelVida
@onready var label_oleada = $UI/LabelOleada

var EnemyScene = preload("res://Escenas/Enemigos/Enemigo1.tscn")
var oleada_actual = 1

func _ready():
	# Conectamos la señal de la base
	var base = get_tree().get_first_node_in_group("base")
	if base:
		base.vida_cambiada.connect(_on_vida_cambiada)
		base.base_destruida.connect(_on_base_destruida)
	spawnear_enemigo()

func spawnear_enemigo():
	var enemigo = EnemyScene.instantiate()
	enemies_container.add_child(enemigo)
	enemigo.inicializar(path)

func _on_vida_cambiada(nueva_vida):
	label_vida.text = "Vida: " + str(nueva_vida)

func _on_base_destruida():
	label_vida.text = "Vida: 0"
	print("GAME OVER")
