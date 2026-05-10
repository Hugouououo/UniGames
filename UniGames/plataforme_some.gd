extends CSGMesh3D

@export var tempo_para_sumir := 2.0
@export var tempo_fade := 0.5 # Tempo da animação de transparência

var ativado := false
var material_proprio: StandardMaterial3D

func _ready():
	# Duplicamos o material para que o fade de uma não afete as outras
	if material:
		material_proprio = material.duplicate()
		material = material_proprio

func iniciar_sumir():
	if ativado:
		return
	
	ativado = true
	
	# Calculamos quanto tempo esperar antes de começar o fade
	var tempo_de_espera = max(0.0, tempo_para_sumir - tempo_fade)
	await get_tree().create_timer(tempo_de_espera).timeout
	
	# Inicia o efeito de Fade Out
	if material_proprio:
		var tween = create_tween()
		var cor_alvo = material_proprio.albedo_color
		cor_alvo.a = 0.0 # Define o alpha (transparência) como zero
		
		# Anima a cor do material até ficar invisível
		tween.tween_property(material_proprio, "albedo_color", cor_alvo, tempo_fade)
		await tween.finished
	
	# Desativa visual e colisão após o fade
	visible = false
	use_collision = false
