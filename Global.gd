extends Node

var nome: String = ""
var ra: String = ""
var checkpoint_pos: Vector3 = Vector3.ZERO

func _ready():
	# Garante que começa zerado sempre que o script carregar
	checkpoint_pos = Vector3.ZERO
