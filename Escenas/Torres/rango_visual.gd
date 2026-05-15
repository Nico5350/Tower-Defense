extends Node2D

var radio: float = 80.0

func _draw():
	# Círculo relleno semitransparente
	draw_circle(Vector2.ZERO, radio, Color(0.2, 0.6, 1.0, 0.15))
	# Borde del círculo
	draw_arc(Vector2.ZERO, radio, 0, TAU, 64, Color(0.2, 0.6, 1.0, 0.6), 1.5)
