extends Area3D

@export var cena_vitoria: String = "res://ranking_table.tscn"
@export var grupo_player: String = "Player"

var terminou := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if terminou:
		return

	if not body.is_in_group(grupo_player):
		return

	terminou = true
	var tempo := _pegar_tempo_da_cena()

	if has_node("/root/Ranking"):
		get_node("/root/Ranking").adicionar(Global.nome, Global.ra, tempo)
	else:
		push_error("Ranking nao configurado. Adicione ranking_manager.gd no AutoLoad com o nome Ranking.")

	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file(cena_vitoria)

func _pegar_tempo_da_cena() -> float:
	var timer_node := _buscar_timer(get_tree().current_scene)
	if timer_node != null and "time_elapsed" in timer_node:
		if timer_node.has_method("stop_timer"):
			timer_node.stop_timer()
		return float(timer_node.time_elapsed)

	return 0.0

func _buscar_timer(node: Node) -> Node:
	if node == null:
		return null

	if "time_elapsed" in node and "timer_started" in node:
		return node

	for child in node.get_children():
		var resultado := _buscar_timer(child)
		if resultado != null:
			return resultado

	return null
