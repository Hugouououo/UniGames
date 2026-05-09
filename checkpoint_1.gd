extends Area3D

# Variável para controlar se este checkpoint já foi usado
var ativado: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Só executa se ainda não foi ativado E se for o jogador
	if not ativado and body.has_method("check_fall"):
		ativado = true # Marca como ativado para nunca mais entrar aqui
		
		Global.checkpoint_pos = global_position
		print("Checkpoint ativado em: ", global_position)
		
		# Chama a função para mostrar o texto na interface
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
