extends Node2D
@export var danio: int = 1
@export var cadencia: float = 1.0
@export var radio: float = 80.0
@export var proyectil_scene: PackedScene
var enemigos_en_rango: Array = []
@onready var area = $Area2D
@onready var timer = $Timer
@onready var rango_visual = $RangoVisual
@onready var collision_shape = $Area2D/CollisionShape2D
func _ready():
	timer.wait_time = cadencia
	timer.timeout.connect(_disparar)
	timer.start()
	area.body_entered.connect(_on_enemigo_entro)
	area.body_exited.connect(_on_enemigo_salio)
	rango_visual.visible = false
	
	# Aplicar el radio configurado en el Inspector a la forma de colisión real
	if collision_shape.shape is CircleShape2D:
		collision_shape.shape = collision_shape.shape.duplicate()
		collision_shape.shape.radius = radio
	
func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	if global_position.distance_to(mouse_pos) <= 16:
		if not rango_visual.visible:
			rango_visual.visible = true
			rango_visual.queue_redraw()
	else:
		rango_visual.visible = false
func _on_enemigo_entro(body):
	if body.is_in_group("enemigos"):
		enemigos_en_rango.append(body)
func _on_enemigo_salio(body):
	if body.is_in_group("enemigos"):
		enemigos_en_rango.erase(body)
func _disparar():
	enemigos_en_rango = enemigos_en_rango.filter(func(e): return is_instance_valid(e))
	if enemigos_en_rango.is_empty():
		return
	
	var objetivo = enemigos_en_rango[0]
	
	# Crear proyectil
	var proyectil = proyectil_scene.instantiate()
	get_tree().root.add_child(proyectil)
	proyectil.global_position = global_position + Vector2(8, 8)
	proyectil.inicializar(objetivo, danio)
