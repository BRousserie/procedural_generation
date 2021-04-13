tool
extends Node2D
class_name Room

enum RoomType {
	START, END, MAIN, BRANCH
}

# cell size in pixels
const CELL_SIZE := 4

# Room size in cell count
const WIDTH := 24
const HEIGHT := 16

var type : int setget set_type
var debug_color : Color

func _ready() -> void:
	generate()


# Generates the room content
func generate() -> void:
	pass


func _draw():
	for y in range(1, HEIGHT):
		var start := Vector2(0, y * CELL_SIZE)
		var end := Vector2(WIDTH * CELL_SIZE, y * CELL_SIZE)
		draw_line(start, end, debug_color)
	
	for x in range(1, WIDTH):
		var start := Vector2(x * CELL_SIZE, 0)
		var end := Vector2(x * CELL_SIZE, HEIGHT * CELL_SIZE)
		draw_line(start, end, debug_color)
	
	var display_rect := Rect2(Vector2.ZERO, Vector2(get_pixel_width(), get_pixel_height()))
	draw_rect(display_rect, Color.green, false, 4.0)


func set_type(new_type: int) -> void:
	type = new_type
	match type:
		RoomType.START:
			debug_color = Color.greenyellow
		RoomType.END:
			debug_color = Color.red
		RoomType.MAIN:
			debug_color = Color.blueviolet
		RoomType.BRANCH:
			debug_color = Color.orange


func get_pixel_width():
	return WIDTH * CELL_SIZE


func get_pixel_height():
	return HEIGHT * CELL_SIZE
