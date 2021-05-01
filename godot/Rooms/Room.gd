tool
extends Node2D
class_name Room

export(PackedScene) var EnemyBaseScene

enum RoomType {
	START, END, MAIN, BRANCH
}

enum CellType {
	EMPTY, WATER, ENEMY, TREASURE, LIGHT, BARREL
}

# cell size in pixels
const CELL_SIZE := 16

# Room size in cell count
const WIDTH := 24
const HEIGHT := 16

enum Door {UP, DOWN, LEFT, RIGHT}

var type : int setget set_type
var location : Vector2
var debug_color : Color

var nb_ponds : int
var nb_enemies : int
var nb_treasures : int
var nb_lights : int
var nb_barrels : int

var _doors := [false, false, false, false]
var cells = []

func _ready() -> void:
	generate()


# Generates the room content
func generate() -> void:
	create_room()
	fill_room()

func create_room() -> void:
	fill_ground()
	place_corners()
	place_walls()
	place_doors()

func fill_ground() -> void:
	for x in range(1, WIDTH-1):
		for y in range(1, HEIGHT-1):
			if (y == 1):
				place_sprite("res://Rooms/Ground/ground_top_"+str(randi() % 3 + 1)+".tres", x * CELL_SIZE, CELL_SIZE)
			elif (y == HEIGHT - 2):
				place_sprite("res://Rooms/Ground/ground_bottom_"+str(randi() % 3 + 1)+".tres", x * CELL_SIZE, CELL_SIZE * (HEIGHT-2))
			elif (x == 1):
				place_sprite("res://Rooms/Ground/ground_left_"+str(randi() % 3 + 1)+".tres", CELL_SIZE, y * CELL_SIZE)
			elif (x == WIDTH - 2):
				place_sprite("res://Rooms/Ground/ground_right_"+str(randi() % 3 + 1)+".tres", CELL_SIZE * (WIDTH-2), y * CELL_SIZE)
			else: 
				place_sprite("res://Rooms/Ground/ground_"+str(randi()%7+1)+".tres", x * CELL_SIZE, y * CELL_SIZE)

func place_corners() -> void:
	for x in range(2):
		for y in range(2):
			place_sprite("res://Rooms/Ground/ground_angle"+str(x)+str(y)+".tres",
			CELL_SIZE + x * CELL_SIZE * (WIDTH-3), CELL_SIZE + y * CELL_SIZE * (HEIGHT-3))

func place_walls() -> void:
	for x in range(WIDTH):
		for y in range(HEIGHT):
			if (x == 0 || y == 0 || x == WIDTH-1 || y == HEIGHT-1):
				place_sprite("res://Rooms/wall.tres", x * CELL_SIZE, y * CELL_SIZE)

func place_doors() -> void:
	for i in range(4):
		if _doors[i]:
			var pos: Vector2 = _get_door_pixel_position(i)
			place_sprite("res://Rooms/door.tres", pos.x, pos.y)

func fill_room() -> void:
	place_ponds()
	place_treasures()
	place_barrels()
	place_lights()
	place_enemies()

func place_ponds() -> void:
	for i in range(nb_ponds):
		place_item("res://Rooms/pond.tres", 2, CellType.WATER)

func place_treasures() -> void:
	for i in range(nb_treasures):
		place_item("res://Rooms/treasure.tres", 1, CellType.TREASURE)

func place_barrels() -> void:
	for i in range(nb_barrels):
		place_item("res://Rooms/barrel.tres", 1, CellType.BARREL)

func place_lights() -> void:
	for i in range(nb_lights):
		place_item("res://Rooms/light.tres", 1, CellType.LIGHT)


func place_enemies() -> void:
	var new_enemy_scene : Node2D = EnemyBaseScene.instance()
	var new_enemy := new_enemy_scene as Enemy
	
	new_room.type = type
	new_room.location = location
	new_room_scene.position = Vector2(x * new_room.get_pixel_width(), y * new_room.get_pixel_height())

	
func place_item(var path, var margin, var celltype) -> void:
	var sprite = Sprite.new()
	sprite.texture = load(path)
	# naive approach, randomly looking for somewhere to place items
	var tries = 10
	for i in range(tries):
		var pos = Vector2(randi() % (WIDTH - margin * 2) + margin, 
			randi() % (HEIGHT - margin * 2) + margin)
		var placeable = true
		for x in range (pos.x, pos.x + sprite.texture.WIDTH):
			for y in range (pos.y, pos.y + sprite.texture.WIDTH):
				if (cells[Vector2(x, y)] != CellType.EMPTY):
					placeable = false
		if (placeable):
			i = tries
			sprite.position = pos
			add_child(sprite)
			for x in range (pos.x, pos.x + sprite.texture.WIDTH):
				for y in range (pos.y, pos.y + sprite.texture.WIDTH):
					cells[Vector2(x, y)] = celltype

func place_sprite(var path, var x, var y) -> void:
	var sprite = Sprite.new()
	sprite.texture = load(path)
	sprite.position = Vector2(x + CELL_SIZE/2, y + CELL_SIZE/2)
	add_child(sprite)

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
