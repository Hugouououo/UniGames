extends Control

@onready var btn_iniciar: Button = $CenterContainer/VBoxContainer/ButtonIniciar
@onready var btn_controles: Button = $CenterContainer/VBoxContainer/ButtonControles
@onready var btn_creditos = $CenterContainer/VBoxContainer/ButtonCreditos

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	btn_iniciar.pressed.connect(_iniciar)
	btn_controles.pressed.connect(_controles)
	btn_creditos.pressed.connect(_creditos)

func _iniciar():
	get_tree().change_scene_to_file("res://menu.tscn")

func _controles():
	get_tree().change_scene_to_file("res://controles_menu.tscn")

func _creditos():
	get_tree().change_scene_to_file("res://Creditos.tscn")
