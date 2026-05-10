extends Control

@onready var input_nome = $VBoxContainer/LineEdit
@onready var input_ra = $VBoxContainer/LineEdit2
@onready var botao = $VBoxContainer/Button

func _ready():
	botao.pressed.connect(_on_botao_pressed)

func _on_botao_pressed():
	var nome = input_nome.text
	var ra = input_ra.text
	
	if nome == "" or ra == "":
		print("Preencha todos os campos!")
		return
	
	# Salvar dados (global)
	Global.nome = nome
	Global.ra = ra
	
	# Trocar de cena
	get_tree().change_scene_to_file("res://principal.tscn")
