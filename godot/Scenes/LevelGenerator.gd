extends Node2D

export(Resource) var difficulty

func _on_ButtonGenerate_pressed() -> void:
	($Level as Level).generate(difficulty)
