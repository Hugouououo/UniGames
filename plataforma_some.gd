extends CSGMesh3D

@export var tempo_para_sumir := 1.0
@export var tempo_para_voltar := 3.0

var ativado := false

func iniciar_sumir():
	if ativado:
		return
	
	ativado = true
	
	await get_tree().create_timer(tempo_para_sumir).timeout
	
	visible = false
	use_collision = false
	
	await get_tree().create_timer(tempo_para_voltar).timeout
	
	visible = true
	use_collision = true
	ativado = false
