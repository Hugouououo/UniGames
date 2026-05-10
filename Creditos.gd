extends Control

@onready var button_voltar = $CenterContainer/VBoxContainer/ButtonVoltar

func _ready():
	button_voltar.pressed.connect(_voltar)

func _voltar():
	get_tree().change_scene_to_file("res://MenuPrincipal.tscn")
