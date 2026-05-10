extends Node

const CAMINHO_RANKING := "user://ranking.json"
const LIMITE_RANKING := 10

var ranking: Array = []

func _ready() -> void:
	carregar()

func carregar() -> void:
	if not FileAccess.file_exists(CAMINHO_RANKING):
		ranking = []
		return

	var file := FileAccess.open(CAMINHO_RANKING, FileAccess.READ)
	if file == null:
		ranking = []
		return

	var texto := file.get_as_text()
	file.close()

	var data = JSON.parse_string(texto)
	if data is Array:
		ranking = data
	else:
		ranking = []

	ordenar_e_limitar()

func salvar() -> void:
	var file := FileAccess.open(CAMINHO_RANKING, FileAccess.WRITE)
	if file == null:
		push_error("Nao foi possivel salvar o ranking.")
		return

	file.store_string(JSON.stringify(ranking, "\t"))
	file.close()

func adicionar(nome: String, ra: String, tempo: float) -> void:
	var nome_limpo := nome.strip_edges()
	var ra_limpo := ra.strip_edges()

	if nome_limpo == "":
		nome_limpo = "Sem nome"

	if ra_limpo == "":
		ra_limpo = "Sem RA"

	ranking.append({
		"nome": nome_limpo,
		"ra": ra_limpo,
		"tempo": tempo,
		"data": Time.get_datetime_string_from_system()
	})

	ordenar_e_limitar()
	salvar()

func ordenar_e_limitar() -> void:
	ranking.sort_custom(func(a, b): return float(a.get("tempo", 999999.0)) < float(b.get("tempo", 999999.0)))

	if ranking.size() > LIMITE_RANKING:
		ranking = ranking.slice(0, LIMITE_RANKING)

func get_top_10() -> Array:
	carregar()
	return ranking.slice(0, min(ranking.size(), LIMITE_RANKING))

func limpar() -> void:
	ranking = []
	salvar()

func formatar_tempo(tempo: float) -> String:
	var minutos := int(tempo / 60.0)
	var segundos := int(tempo) % 60
	var centesimos := int((tempo - int(tempo)) * 100.0)
	return "%02d:%02d:%02d" % [minutos, segundos, centesimos]
