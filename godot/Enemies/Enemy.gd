extends Node2D




var generator: EnemyGenerator
var res: Array


func _ready() -> void:
	
	randomize()
	generate()


# Generates a new level
func generate() -> void:
	generator = EnemyGenerator.new()
	res = generator.GenerateEnemy(5, 1)
	dr()

func _input(ev):
	
	if ev is InputEventKey and ev.scancode == KEY_K and not ev.pressed:
		for n in get_children():
			remove_child(n)
			n.queue_free()
		generator.GenerateNextStep()
		dr()
	
	

func dr():
	var type
	for i in range(5):
		for j in range(5):
			if(res[i][j].possibilities.size() == 1):
				var sprite = Sprite.new()
				type = res[i][j].possibilities[0].type
				sprite.texture = load("res://Enemies/"+str(type)+".PNG")
				sprite.position = Vector2(j* 60 + 25, i *60 +25)
				sprite.scale = Vector2(0.5, 0.5)
				add_child(sprite)

			if(res[i][j].possibilities.size() > 1):
				for k in range(res[i][j].possibilities.size()):
					var sprite = Sprite.new()
					type = res[i][j].possibilities[k].type
					sprite.texture = load("res://Enemies/"+str(type)+".PNG")
					sprite.position = Vector2(j* 60 +(50/4)/2 + (50/4) * (k%4), i *60 +(50/4)/2+ (50/4) * (k/4))
					sprite.scale = Vector2(0.125, 0.125)
					add_child(sprite)
