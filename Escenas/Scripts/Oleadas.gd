# oleadas.gd
extends Node

signal oleada_iniciada(numero)
signal oleada_completada(numero)
signal todos_enemies_muertos

# Definicion de oleadas
var oleadas = [
	# Oleada 1: 5 enemigos lentos
	{"cantidad": 3, "intervalo": 2.0, "velocidad": 60.0, "vida": 3},
	# Oleada 2: 8 enemigos un poco mas rapidos
	{"cantidad": 8, "intervalo": 1.5, "velocidad": 80.0, "vida": 4},
	# Oleada 3: 12 enemigos rapidos
	{"cantidad": 12, "intervalo": 1.0, "velocidad": 100.0, "vida": 5},
]

var oleada_actual = 0
var enemigos_spawneados = 0
var enemigos_vivos = 0
var spawneando = false

var path: Path2D
var enemies_container: Node
var EnemyScene: PackedScene

func inicializar(p: Path2D, container: Node, scene: PackedScene):
	path = p
	enemies_container = container
	EnemyScene = scene

func iniciar_oleada():
	if oleada_actual >= oleadas.size():
		print("¡Ganaste! No hay más oleadas")
		return
	
	spawneando = true
	enemigos_spawneados = 0
	var datos = oleadas[oleada_actual]
	enemigos_vivos = datos["cantidad"]
	
	emit_signal("oleada_iniciada", oleada_actual + 1)
	print("Iniciando oleada ", oleada_actual + 1)
	
	# Timer para spawnear enemigos uno por uno
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = datos["intervalo"]
	timer.timeout.connect(_spawnear_siguiente.bind(timer))
	timer.start()
	
	# Spawneamos el primero inmediatamente
	_spawnear_enemigo()
	enemigos_spawneados += 1

func _spawnear_siguiente(timer: Timer):
	var datos = oleadas[oleada_actual]
	
	if enemigos_spawneados < datos["cantidad"]:
		_spawnear_enemigo()
		enemigos_spawneados += 1
	else:
		timer.queue_free()
		spawneando = false

func _spawnear_enemigo():
	var datos = oleadas[oleada_actual]
	var enemigo = EnemyScene.instantiate()
	enemies_container.add_child(enemigo)
	enemigo.inicializar(path)
	# Aplicamos stats de la oleada
	enemigo.velocidad = datos["velocidad"]
	enemigo.vida = datos["vida"]
	# Avisamos cuando muera
	enemigo.tree_exited.connect(_on_enemigo_muerto)

func _on_enemigo_muerto():
	enemigos_vivos -= 1
	if enemigos_vivos <= 0 and not spawneando:
		emit_signal("oleada_completada", oleada_actual + 1)
		oleada_actual += 1
