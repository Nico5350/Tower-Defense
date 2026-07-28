# base.gd
extends Area2D
@export var vida_maxima: int = 20
var vida_actual: int
signal vida_cambiada(nueva_vida)
signal base_destruida
@onready var progress_bar = $ProgressBar
func _ready():
	vida_actual = vida_maxima
	progress_bar.max_value = vida_maxima
	progress_bar.value = vida_actual
func recibir_danio(cantidad: int):
	vida_actual -= cantidad
	progress_bar.value = vida_actual
	emit_signal("vida_cambiada", vida_actual)
	print("Base recibió daño. Vida restante: ", vida_actual)
	
	if vida_actual <= 0:
		destruir()
func destruir():
	emit_signal("base_destruida")
	print("¡Base destruida! Game Over")
