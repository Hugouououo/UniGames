extends Area3D


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		print("Lava atingida! Reiniciando a fase...")

		get_tree().reload_current_scene()
