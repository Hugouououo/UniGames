extends CSGMesh3D # Alterado para CSGMesh3D para acessar o material diretamente

@export var tempo := 3.0
@export var tempo_fade := 0.5 # Tempo que a plataforma leva sumindo (fade-out)
@export var comeca_visivel := false

var visivel := true
var material_proprio : StandardMaterial3D

func _ready():
	# Duplica o material para que o fade de uma plataforma não afete as outras
	if material != null:
		material_proprio = material.duplicate()
		material = material_proprio
	
	visivel = comeca_visivel
	
	# Ajusta a transparência inicial dependendo de como a plataforma começa
	if material_proprio:
		var cor = material_proprio.albedo_color
		cor.a = 1.0 if visivel else 0.0
		material_proprio.albedo_color = cor
		
	atualizar_estado()
	ciclo()

func ciclo():
	while true:
		if visivel:
			# Espera o tempo total MENOS o tempo que leva para fazer o fade
			await get_tree().create_timer(max(0.1, tempo - tempo_fade)).timeout
			
			# Inicia a animação de fade-out (do alpha 1.0 para o 0.0)
			await fazer_fade(1.0, 0.0, tempo_fade)
			
			visivel = false
			atualizar_estado()
		else:
			# Espera o tempo invisível
			await get_tree().create_timer(tempo).timeout
			
			visivel = true
			# Restaura a opacidade instantaneamente ao reaparecer
			if material_proprio:
				var cor = material_proprio.albedo_color
				cor.a = 1.0
				material_proprio.albedo_color = cor
				
			atualizar_estado()

func fazer_fade(alpha_inicial: float, alpha_final: float, duracao: float):
	if not material_proprio:
		return
		
	var tween = create_tween()
	var cor_alvo = material_proprio.albedo_color
	cor_alvo.a = alpha_final
	
	# Anima a propriedade albedo_color até a cor_alvo (que tem o alpha zerado)
	tween.tween_property(material_proprio, "albedo_color", cor_alvo, duracao)
	await tween.finished

func atualizar_estado():
	# Quando está invisível, desativamos a visibilidade do nó e a colisão
	visible = visivel
	use_collision = visivel
