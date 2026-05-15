extends Node2D

@export var danio: int = 1
@export var cadencia: float = 1.0
@export var radio: float = 80.0

var enemigos_en_rango: Array = []

@onready var area = $Area2D
@onready var timer = $Timer
@onready var rango_visual = $RangoVisual

func _ready():
	timer.wait_time = cadencia
	timer.timeout.connect(_disparar)
	timer.start()
	area.body_entered.connect(_on_enemigo_entro)
	area.body_exited.connect(_on_enemigo_salio)
	# El círculo empieza invisible
	rango_visual.visible = false

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	# Si el mouse está encima de la torre
	if global_position.distance_to(mouse_pos) <= 16:
		if not rango_visual.visible:
			rango_visual.visible = true
			rango_visual.queue_redraw()
	else:
		rango_visual.visible = false

func mostrar_rango():
	rango_visual.visible = true
	rango_visual.queue_redraw()

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
	objetivo.recibir_danio(danio)
