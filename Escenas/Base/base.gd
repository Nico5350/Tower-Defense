# base.gd
extends Area2D

@export var vida_maxima: int = 20
var vida_actual: int

signal vida_cambiada(nueva_vida)
signal base_destruida

func _ready():
	vida_actual = vida_maxima

func recibir_danio(cantidad: int):
	vida_actual -= cantidad
	emit_signal("vida_cambiada", vida_actual)
	print("Base recibió daño. Vida restante: ", vida_actual)
	
	if vida_actual <= 0:
		destruir()

func destruir():
	emit_signal("base_destruida")
	print("¡Base destruida! Game Over")
