extends Node2D
class_name Enemy



var generator: EnemyGenerator
var res: Array

var size = 10

var wait_input = false

func _ready() -> void:
	
	randomize()
	generate()


# Generates a new level
func generate() -> void:
	var start_time = OS.get_system_time_msecs()
	generator = EnemyGenerator.new()
	res = generator.GenerateEnemy(size, 10)
	
	if (!wait_input):
		generator.FullyGenerate()
	print(str(OS.get_system_time_msecs() - start_time))
	dr()

func _input(ev):
	
	if ev is InputEventKey and ev.scancode == KEY_K and not ev.pressed and wait_input:
		for n in get_children():
			remove_child(n)
			n.queue_free()
		generator.GenerateNextStep()
		dr()
	
	

func dr():
	var type
	for i in range(size):
		for j in range(size):
			if(res[i][j].possibilities.size() == 1):
				var sprite = Sprite.new()
				type = res[i][j].possibilities[0].type
				sprite.texture = load("res://Enemies/"+str(type)+".PNG")
				sprite.position = Vector2(j* 50 + 25, i *50 +25)
				sprite.scale = Vector2(1, 1)
				add_child(sprite)

			if(res[i][j].possibilities.size() > 1):
				for k in range(res[i][j].possibilities.size()):
					var sprite = Sprite.new()
					type = res[i][j].possibilities[k].type
					sprite.texture = load("res://Enemies/"+str(type)+".PNG")
					sprite.position = Vector2(j* 50 +(50/4)/2 + (50/4) * (k%4), i *50 +(50/4)/2+ (50/4) * (k/4))
					sprite.scale = Vector2(0.25, 0.25)
					add_child(sprite)
