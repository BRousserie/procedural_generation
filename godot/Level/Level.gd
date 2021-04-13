extends Node2D
class_name Level

export(PackedScene) var RoomBaseScene
export(Resource) var debug_difficulty

onready var room_pool := $Rooms

var _rooms := {}
var _noise := OpenSimplexNoise.new()

func _ready() -> void:
	_noise.period = 5.0
	
	generate(debug_difficulty as LevelDifficulty)


# Generates a new level
func generate(difficulty: LevelDifficulty) -> void:
	randomize()
	_noise.seed = randi()
	
	# If some rooms already exist, remove them
	if room_pool.get_child_count() != 0:
		_clear_rooms()
	
	var corridor_dir := randf() * 2 * PI
	
	var start_pos := Vector2(0, 0)
	var end_pos := Vector2(
			int(cos(corridor_dir) * difficulty.level_length),
			int(sin(corridor_dir) * difficulty.level_length))

	_create_room_at(end_pos.x, end_pos.y, Room.RoomType.END)
	_create_room_at(start_pos.x, start_pos.y, Room.RoomType.START)

	var pos := Vector2(start_pos)
	while pos != end_pos:
		
		if not _is_room_at(pos.x, pos.y):
			_create_room_at(pos.x, pos.y, Room.RoomType.MAIN)
		else:
			print("ALERT ROOM AT")
		
		var dir := end_pos - pos
		
		var angle_variation = _noise.get_noise_2d(pos.x, pos.y) * PI / 2
		dir = dir.rotated(angle_variation)

		var card_dir := _choose_cardinal_dir(dir)
		
		pos += card_dir


# Returns a 4 directions approximation of the given direction
func _choose_cardinal_dir(direction: Vector2) -> Vector2:
	var dirs := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	var norm_dir := direction.normalized()
	
	var closest_value := -1.0
	var closest_dir : Vector2
	
	var dir_weights := {}
	var weights := []
	var weight_total := 0
	
	for dir in dirs:
		var value = norm_dir.dot(dir)
		if value > closest_value:
			closest_value = value
			closest_dir = dir
			
	return closest_dir


func _clear_rooms() -> void:
	_rooms.clear()
	for r in room_pool.get_children():
		r.queue_free()


func _create_room_at(x: int, y: int, type := Room.RoomType.MAIN) -> void:
	var new_room_scene : Node2D = RoomBaseScene.instance()
	var new_room := new_room_scene as Room
	new_room.set_type(type)
	new_room_scene.position = Vector2(x * new_room.get_pixel_width(), y * new_room.get_pixel_height())
	_rooms[Vector2(x, y)] = new_room
	room_pool.add_child(new_room_scene)

func _is_room_at(x: int, y: int) -> bool:
	return _rooms.has(Vector2(x, y))
