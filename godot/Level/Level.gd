extends Node2D
class_name Level

export(PackedScene) var RoomBaseScene

onready var room_pool := $Rooms

# Generation variable
var _noise := OpenSimplexNoise.new()
var _rooms := {} # Room coordinates
var _room_progression_values := {}
var _corridor_sequence = [] # Room order in main corridor

func _ready() -> void:
	_noise.period = 5.0

# Generates a new level
func generate(difficulty: LevelDifficulty) -> void:
	randomize()
	_noise.seed = randi()
	
	# If some rooms already exist, remove them
	if room_pool.get_child_count() != 0:
		_clear_rooms()
	
	_generation_main_corridor_pass(difficulty)
	_generation_branches_pass(difficulty)
	_generation_fill_rooms_pass(difficulty)


# Generates the main corridor
func _generation_main_corridor_pass(difficulty: LevelDifficulty) -> void:
	var corridor_dir := randf() * 2 * PI

	var start_pos := Vector2(0, 0)
	var end_pos := Vector2(
			int(cos(corridor_dir) * difficulty.level_length),
			int(sin(corridor_dir) * difficulty.level_length))

	var start_room := _create_room_at(start_pos.x, start_pos.y, Room.RoomType.START)
	_room_progression_values[start_room] = 0.0
	var previous_room := start_room

	var pos := Vector2(start_pos)
	var last_dir := Vector2.ZERO

	while pos != end_pos:
		var dir := end_pos - pos
		
		var angle_variation = _noise.get_noise_2d(pos.x, pos.y) * PI / 2
		dir = dir.rotated(angle_variation)

		var card_dir := _choose_cardinal_dir(dir)
		
		last_dir = card_dir
		pos += card_dir
		
		if not _is_room_at(pos.x, pos.y):
			var room_type = Room.RoomType.END if pos == end_pos else Room.RoomType.MAIN
			var room := _create_room_at(pos.x, pos.y, room_type)
			var index := _get_card_index_from_dir(last_dir)
			previous_room.set_door(index)
			room.set_door(room.get_opposite_door(index))
			_corridor_sequence.append(room)
			
			previous_room = room


# Generates the branches on the main corridor
func _generation_branches_pass(difficulty: LevelDifficulty) -> void:
	var branch_count := difficulty.avg_branch_count + randi() % 3 - 1 
	var room_count : int = _corridor_sequence.size()
	var avg_space := room_count / branch_count
	
	var next_branch := avg_space
	var progress := 0.0
	
	# room difficulties
	var level_progression = 0.0
	var progression_increment = 1.0 / float(room_count)
	
	for room in _corridor_sequence:
		next_branch -= 1
		progress += 1.0
		level_progression += progression_increment
		_room_progression_values[room] = level_progression
		
		if next_branch == 0:
			next_branch = avg_space
			var percent : float = progress / room_count
			var branch_len : int = difficulty.min_branch_size + difficulty.branch_size_scale.interpolate(percent) * (difficulty.max_branch_size - difficulty.min_branch_size) 
			_create_branch_at(room, branch_len, level_progression)


func _generation_fill_rooms_pass(difficulty: LevelDifficulty) -> void:
	for room in _rooms.values():
		room.generate(difficulty, _room_progression_values[room])


# Creates a branch of a fixed size from a room, returns false if not enough space
func _create_branch_at(room: Room, length: int, level_progression : float) -> bool:
	if room.type != Room.RoomType.MAIN:
		return false
	
	var previous_room := room
	for i in range(length):
		var pos := previous_room.location
		
		# Check all available directions
		var available_dirs := []
		for dir in Globals.CARD_DIRS:
			var check_pos = pos + dir
			if not _is_room_at(check_pos.x, check_pos.y):
				available_dirs.append(dir)
		
		if available_dirs.size() == 0:
			return false
		
		var rand_dir : Vector2 = available_dirs[randi() % available_dirs.size()]
		var rand_pos = pos + rand_dir
		
		var index := _get_card_index_from_dir(rand_dir)
		var new_room := _create_room_at(rand_pos.x, rand_pos.y, Room.RoomType.BRANCH)
		_room_progression_values[new_room] = level_progression
		previous_room.set_door(index)
		new_room.set_door(new_room.get_opposite_door(index))
		
		previous_room = new_room
	
	return true


# Returns a 4 directions approximation of the given direction
func _choose_cardinal_dir(direction: Vector2) -> Vector2:
	return Globals.CARD_DIRS[_get_card_index_from_dir(direction)]


# Get a cardinal direction index from any direction vector
func _get_card_index_from_dir(direction: Vector2) -> int:
	# Solve trivial cases
	match direction:
		Vector2.UP: return 0
		Vector2.DOWN: return 1
		Vector2.LEFT: return 2
		Vector2.RIGHT: return 3
	
	var norm_dir := direction.normalized()
	
	var closest_value := -1.0
	var closest_card : int
	var dir_weights := {}
	var weights := []
	var weight_total := 0
	
	for i in range(Globals.CARD_DIRS.size()):
		var dir : Vector2 = Globals.CARD_DIRS[i]
		var value = norm_dir.dot(dir)
		if value > closest_value:
			closest_value = value
			closest_card = i
	
	return closest_card


func _clear_rooms() -> void:
	_rooms.clear()
	_corridor_sequence.clear()
	for r in room_pool.get_children():
		r.queue_free()


func _create_room_at(x: int, y: int, type : int) -> Room:
	var location := Vector2(x, y)
	var new_room_scene : Node2D = RoomBaseScene.instance()
	var new_room := new_room_scene as Room
	
	new_room.type = type
	new_room.location = location
	new_room_scene.position = Vector2(x * new_room.get_pixel_width(), y * new_room.get_pixel_height())
	_rooms[location] = new_room
	room_pool.add_child(new_room_scene)
	
	return new_room


func _is_room_at(x: int, y: int) -> bool:
	return _rooms.has(Vector2(x, y))
