extends Node2D

export(Array) var difficulties

onready var difficulty_select = $UI/GUI/Margin/LeftMenu/HBoxContainer/DifficultySelect

func _on_ButtonGenerate_pressed() -> void:
	($Level as Level).generate(difficulties[difficulty_select.selected])
