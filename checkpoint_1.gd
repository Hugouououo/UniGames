extends Area3D

# Variável para controlar se este checkpoint já foi usado
var ativado: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not ativado and body.has_method("check_fall"):
		ativado = true 
		Global.checkpoint_pos = global_position
		# Pega a rotação Y do checkpoint (em radianos)
		Global.checkpoint_rot = global_rotation.y 
		print("Checkpoint alcançado! Pos: ", global_position, " Rot: ", global_rotation.y)
		exibir_mensagem_checkpoint()

func exibir_mensagem_checkpoint():
	# Supondo que você tenha um CanvasLayer com um Label chamado "MensagemLabel"
	# Você pode acessar sua UI via Singleton ou via get_node
	var label = get_tree().root.find_child("LabelCheckpoint", true, false)
	
	if label:
		label.text = "Checkpoint Ativado!"
		label.visible = true
		
		# Espera 1 segundo de forma não bloqueante
		await get_tree().create_timer(2.0).timeout
		
		label.visible = false
