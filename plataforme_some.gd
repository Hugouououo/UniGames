extends StaticBody3D

@export var tempo_para_sumir := 2.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var colisao: CollisionShape3D = $CollisionShape3D
@onready var area: Area3D = $Area3D

var ativado := false

func _ready():
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if ativado:
		return
	
	if body.is_in_group("player"):
		ativado = true
		sumir()

func sumir():
	await get_tree().create_timer(tempo_para_sumir).timeout
	
	mesh.visible = false
	colisao.disabled = true
