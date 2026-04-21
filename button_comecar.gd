func _on_button_pressed():
	var nome = $VBoxContainer/LineNome.text
	var ra = $VBoxContainer/LineRA.text
	
	if nome == "" or ra == "":
		print("Preencha tudo!")
		return
	
	get_tree().change_scene_to_file("res://Principal.tscn")
