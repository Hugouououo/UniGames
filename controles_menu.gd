extends Control

@onready var btn_voltar: Button = $CenterContainer/Panel/VBoxContainer/ButtonVoltar

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	btn_voltar.pressed.connect(_voltar)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_voltar()

func _voltar():
	get_tree().change_scene_to_file("res://MenuPrincipal.tscn")
