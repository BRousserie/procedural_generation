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

enum Door {UP, DOWN, LEFT, RIGHT}

var type : int setget set_type
var location : Vector2
var debug_color : Color

var _doors := [false, false, false, false]

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
	
	# Draw doors
	for i in range(4):
		if _doors[i]:
			var pos: Vector2 = _get_door_pixel_position(i)
			draw_circle(pos, 6, Color.red)


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


func get_pixel_width() -> int:
	return WIDTH * CELL_SIZE


func get_pixel_height() -> int:
	return HEIGHT * CELL_SIZE


func get_room_center() -> Vector2:
	return Vector2(get_pixel_width(), get_pixel_height()) / 2


# Returns the position of a door
func _get_door_pixel_position(door_index: int) -> Vector2:
	var direction : Vector2 = Globals.CARD_DIRS[door_index]
	var dist : int = (get_pixel_height() if door_index < 2 else get_pixel_width()) / 2
	return get_room_center() + direction * dist * 0.9


func set_door(door_index: int, state := true) -> void:
	_doors[door_index] = state


func has_door_at(door_index: int) -> bool:
	return _doors[door_index]


# Returns the opposite index of a door
# Ex: get_opposite_door(Door.LEFT) == Door.RIGHT
func get_opposite_door(door_index: int) -> int:
	var door_offset := 2 if door_index >= 2 else 0 
	return door_offset + 1 - (door_index - door_offset)
