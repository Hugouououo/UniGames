extends Control

@onready var button_continuar: Button = $Panel/HBoxContainer/VBoxBotoes/ButtonContinuar
@onready var button_desistir: Button = $Panel/HBoxContainer/VBoxBotoes/ButtonDesistir

var pausado := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	button_continuar.process_mode = Node.PROCESS_MODE_ALWAYS
	button_desistir.process_mode = Node.PROCESS_MODE_ALWAYS
	
	button_continuar.pressed.connect(continuar)
	button_desistir.pressed.connect(desistir)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		trocar_pause()

func trocar_pause():
	pausado = !pausado
	get_tree().paused = pausado
	visible = pausado
	
	if pausado:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func continuar():
	if pausado:
		trocar_pause()

func desistir():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://menu.tscn")
