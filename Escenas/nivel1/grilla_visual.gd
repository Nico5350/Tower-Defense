extends Node2D
var nivel: Node2D
func _ready():
	nivel = get_parent()
func _draw():
	if nivel.torre_seleccionada == null:
		return
	
	var viewport_size = get_viewport_rect().size
	var bloque_size = nivel.TILE_SIZE * nivel.TORRE_TILES
	var bloques_x = int(ceil(viewport_size.x / bloque_size))
	var bloques_y = int(ceil(viewport_size.y / bloque_size))
	
	for bx in range(bloques_x):
		for by in range(bloques_y):
			var tile_x = bx * nivel.TORRE_TILES
			var tile_y = by * nivel.TORRE_TILES
			var libre = true
			for dx in range(nivel.TORRE_TILES):
				for dy in range(nivel.TORRE_TILES):
					if nivel.casillas_ocupadas.has(Vector2i(tile_x + dx, tile_y + dy)):
						libre = false
			var color = Color(0, 1, 0, 0.25) if libre else Color(1, 0, 0, 0.25)
			var pos = Vector2(tile_x * nivel.TILE_SIZE, tile_y * nivel.TILE_SIZE)
			var rect = Rect2(pos, Vector2(bloque_size, bloque_size))
			draw_rect(rect, color, true)
			draw_rect(rect, Color(1, 1, 1, 0.4), false, 1.0)
