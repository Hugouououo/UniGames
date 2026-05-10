extends AnimatableBody3D

@export var deslocamento: Vector3 = Vector3(5, 0, 0) # Move 5 metros no eixo X
@export var duracao: float = 2.0

func _ready():
	# Criamos o tween e garantimos que ele rode no processo de física
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	# Movimento de ida
	tween.tween_property(self, "position", position + deslocamento, duracao).set_trans(Tween.TRANS_SINE)
	
	# Movimento de volta
	tween.tween_property(self, "position", position, duracao).set_trans(Tween.TRANS_SINE)
