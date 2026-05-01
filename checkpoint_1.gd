extends Area3D

func _ready():
	# Conecta o sinal que detecta quando algo entra na área
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Verifica se o objeto que entrou tem o método de queda (seu Player)
	if body.has_method("check_fall"):
		Global.checkpoint_pos = global_position
		print("Checkpoint ativado em: ", global_position)
