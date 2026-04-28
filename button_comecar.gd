extends Button

@onready var line_nome = $"../LineNome"
@onready var line_ra = $"../LineRA"
@onready var label_erro = $"../LabelErro"

func _on_pressed():
	var nome = line_nome.text.strip_edges()
	var ra = line_ra.text.strip_edges()
	
	if nome == "" or ra == "":
		label_erro.visible = true
		
		await get_tree().create_timer(2.0).timeout
		label_erro.visible = false
		
		return
	
	label_erro.visible = false
	
	Global.nome = nome
	Global.ra = ra
	
	get_tree().change_scene_to_file("res://principal.tscn")
