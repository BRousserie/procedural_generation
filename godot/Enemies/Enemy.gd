extends Node2D




var generator: EnemyGenerator
var res: Array


func _ready() -> void:
	
	generate()


# Generates a new level
func generate() -> void:
	generator = EnemyGenerator.new()
	res = generator.GenerateEnemy(10, 1)

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_K:
		generator.GenerateNextStep()
		
	var sprite = Sprite.new()
	sprite.texture = load("res://Enemies/1.PNG")
	$Node.add_child(sprite)
