extends Node

var nome: String = ""
var ra: String = ""
var checkpoint_pos: Vector3 = Vector3.ZERO
var checkpoint_rot : float = 0.0  # <--- ADICIONE ESTA LINHA AQUI

func _ready():
	# Garante que começa zerado sempre que o script carregar
	checkpoint_pos = Vector3.ZERO
