extends Control

@onready var grid: GridContainer = $Panel/MarginContainer/VBoxContainer/GridContainer
@onready var label_status: Label = $Panel/MarginContainer/VBoxContainer/LabelStatus
@onready var button_fechar: Button = $Panel/MarginContainer/VBoxContainer/ButtonFechar

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	button_fechar.pressed.connect(_on_button_fechar_pressed)
	atualizar_tabela()

func atualizar_tabela() -> void:
	limpar_grid()
	criar_cabecalho()

	if not has_node("/root/Ranking"):
		label_status.text = "Ranking nao configurado. Adicione ranking_manager.gd no AutoLoad com o nome Ranking."
		return

	var dados: Array = get_node("/root/Ranking").get_top_10()

	if dados.is_empty():
		label_status.text = "Ainda nao ha tempos salvos."
		return

	label_status.text = "Top 10 melhores tempos"

	for i in range(dados.size()):
		var item: Dictionary = dados[i]
		adicionar_linha(
			str(i + 1),
			str(item.get("nome", "")),
			str(item.get("ra", "")),
			get_node("/root/Ranking").formatar_tempo(float(item.get("tempo", 0.0)))
		)

func limpar_grid() -> void:
	for child in grid.get_children():
		child.queue_free()

func criar_cabecalho() -> void:
	adicionar_label("#", true)
	adicionar_label("Nome", true)
	adicionar_label("RA", true)
	adicionar_label("Tempo", true)

func adicionar_linha(posicao: String, nome: String, ra: String, tempo: String) -> void:
	adicionar_label(posicao)
	adicionar_label(nome)
	adicionar_label(ra)
	adicionar_label(tempo)

func adicionar_label(texto: String, cabecalho := false) -> void:
	var label := Label.new()
	label.text = texto
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(120, 32)
	label.add_theme_font_size_override("font_size", 22 if cabecalho else 18)
	grid.add_child(label)

func _on_button_fechar_pressed() -> void:
	visible = false
