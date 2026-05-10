extends CSGMesh3D

@export var tempo_para_sumir := 2.0
@export var tempo_fade := 0.5 
@export var tempo_para_voltar := 3.0 # Tempo que ela fica invisível antes de retornar

var ativado := false
var material_proprio: StandardMaterial3D
var cor_original: Color

func _ready():
	if material:
		material_proprio = material.duplicate()
		material = material_proprio
		cor_original = material_proprio.albedo_color

func iniciar_sumir():
	if ativado:
		return
	
	ativado = true
	
	# --- FASE 1: SUMIR ---
	var tempo_de_espera = max(0.0, tempo_para_sumir - tempo_fade)
	await get_tree().create_timer(tempo_de_espera).timeout
	
	if material_proprio:
		var tween_out = create_tween()
		var cor_invisivel = cor_original
		cor_invisivel.a = 0.0
		tween_out.tween_property(material_proprio, "albedo_color", cor_invisivel, tempo_fade)
		await tween_out.finished
	
	visible = false
	use_collision = false

	# --- FASE 2: ESPERAR E VOLTAR ---
	await get_tree().create_timer(tempo_para_voltar).timeout
	
	# Resetar propriedades básicas
	visible = true
	use_collision = true
	
	# Efeito de Fade In (opcional, para não aparecer do nada)
	if material_proprio:
		var tween_in = create_tween()
		tween_in.tween_property(material_proprio, "albedo_color", cor_original, tempo_fade)
		await tween_in.finished
	
	# Permitir que o processo aconteça novamente
	ativado = false
