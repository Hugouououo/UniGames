#func _on_button_pressed():
	#var nome = $VBoxContainer/LineNome.text
	#var ra = $VBoxContainer/LineRA.text
	#
	#if nome == "" or ra == "":
		#print("Preencha tudo!")
		#return
	#
	#get_tree().change_scene_to_file("res://Principal.tscn")

extends Button
# Como o LineNome e o ButtonComecar estão no mesmo nível, 
# basta usar ".." para referenciar o próprio nível ou usar o nome direto se fossem filhos.
# Para a sua árvore, o caminho correto é este:
@onready var line_nome = get_node("../LineNome")
@onready var line_ra = get_node("../LineRA")

func _on_pressed():
	var nome = line_nome.text
	var ra = line_ra.text
	
	if nome == "" or ra == "":
		print("Preencha tudo!")
		return
	
	print("Indo para a cena principal...")
	get_tree().change_scene_to_file("res://principal.tscn")
