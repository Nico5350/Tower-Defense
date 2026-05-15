extends Node2D

@export var velocidad: float = 80.0
@export var vida: int = 3

var path_follow: PathFollow2D
var path: Path2D

func inicializar(p: Path2D):
	path = p
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.loop = false
	path_follow.rotates = false

func _process(delta):
	if path_follow == null:
		return
	path_follow.progress += velocidad * delta
	global_position = path_follow.global_position
	if path_follow.progress_ratio >= 1.0:
		llego_a_la_base()

func llego_a_la_base():
	# Buscamos la base y le restamos vida
	var base = get_tree().get_first_node_in_group("base")
	if base:
		base.recibir_danio(1)
	path_follow.queue_free()
	queue_free()

func recibir_danio(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		morir()

func morir():
	print("Enemigo muerto")
	path_follow.queue_free()
	queue_free()
