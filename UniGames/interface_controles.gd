extends Control

var tempo := 0.0
var iniciado := false

@onready var label_tempo = $LabelCenter

func _process(delta):
	if iniciado:
		tempo += delta
		label_tempo.text = formatar_tempo(tempo)

func _input(event):
	if not iniciado and event is InputEventKey and event.pressed:
		iniciado = true

func resetar():
	tempo = 0.0
	iniciado = false
	label_tempo.text = "00:00:00"

func formatar_tempo(t):
	var minutos = int(t / 60)
	var segundos = int(t) % 60
	var ms = int((t - int(t)) * 100)
	return "%02d:%02d:%02d" % [minutos, segundos, ms]
