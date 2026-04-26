extends Node3D

@export var tempo := 3.0
@export var comeca_visivel := false

@onready var mesh = self

var visivel := true

func _ready():
	visivel = comeca_visivel
	atualizar_estado()
	ciclo()

func ciclo():
	while true:
		await get_tree().create_timer(tempo).timeout
		visivel = !visivel
		atualizar_estado()

func atualizar_estado():
	mesh.visible = visivel
	mesh.use_collision = visivel
