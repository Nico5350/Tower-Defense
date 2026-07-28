# oleadas.gd
extends Node
signal oleada_iniciada(numero)
signal oleada_completada(numero)
signal todos_enemies_muertos
# Lista de oleadas, editable desde el Inspector (cada elemento es un OleadaData)
@export var lista_oleadas: Array[OleadaData] = []
var oleada_actual = 0
var enemigos_vivos = 0
var spawneando = false
var path: Path2D
var enemies_container: Node
var enemy_scenes: Dictionary
var cola_actual: Array = []
func inicializar(p: Path2D, container: Node, scenes: Dictionary):
	path = p
	enemies_container = container
	enemy_scenes = scenes
func iniciar_oleada():
	if oleada_actual >= lista_oleadas.size():
		print("¡Ganaste! No hay más oleadas")
		return
	
	spawneando = true
	var datos: OleadaData = lista_oleadas[oleada_actual]
	cola_actual = _construir_cola(datos.grupos)
	enemigos_vivos = cola_actual.size()
	
	emit_signal("oleada_iniciada", oleada_actual + 1)
	print("Iniciando oleada ", oleada_actual + 1)
	
	# Salvaguarda: si la oleada no tiene enemigos configurados, completarla directamente
	if cola_actual.is_empty():
		print("ADVERTENCIA: oleada ", oleada_actual + 1, " no tiene enemigos configurados")
		spawneando = false
		emit_signal("oleada_completada", oleada_actual + 1)
		oleada_actual += 1
		return
	
	# Timer para spawnear enemigos uno por uno
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = datos.intervalo
	timer.timeout.connect(_spawnear_siguiente.bind(timer))
	timer.start()
	
	# Spawneamos el primero inmediatamente
	_spawnear_enemigo()
func _construir_cola(grupos: Array[GrupoEnemigo]) -> Array:
	var cola = []
	for grupo in grupos:
		for i in range(grupo.cantidad):
			cola.append(grupo)
	cola.shuffle()
	return cola
func _spawnear_siguiente(timer: Timer):
	if not cola_actual.is_empty():
		_spawnear_enemigo()
	else:
		timer.queue_free()
		spawneando = false
func _spawnear_enemigo():
	if cola_actual.is_empty():
		return
	var grupo: GrupoEnemigo = cola_actual.pop_front()
	var EnemyScene = enemy_scenes[grupo.tipo]
	var enemigo = EnemyScene.instantiate()
	enemies_container.add_child(enemigo)
	enemigo.inicializar(path)
	enemigo.velocidad = grupo.velocidad
	enemigo.vida = grupo.vida
	enemigo.tree_exited.connect(_on_enemigo_muerto)
func _on_enemigo_muerto():
	enemigos_vivos -= 1
	if enemigos_vivos <= 0 and not spawneando:
		emit_signal("oleada_completada", oleada_actual + 1)
		oleada_actual += 1
