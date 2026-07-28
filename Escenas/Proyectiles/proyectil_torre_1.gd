extends Area2D
@export var velocidad: float = 200.0
var danio: int = 1
var objetivo: Node2D = null
func inicializar(target: Node2D, dmg: int):
	objetivo = target
	danio = dmg
func _process(delta):
	if not is_instance_valid(objetivo):
		queue_free()
		return
	
	var direccion = (objetivo.global_position - global_position).normalized()
	global_position += direccion * velocidad * delta
	
	if global_position.distance_to(objetivo.global_position) < 8:
		objetivo.recibir_danio(danio)
		queue_free()
