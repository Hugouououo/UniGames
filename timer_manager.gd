extends Node

var timer_started := false
var time_elapsed := 0.0

@export var label: Label

func _process(delta):
	if timer_started:
		time_elapsed += delta
		
		if label:
			label.text = format_time(time_elapsed)

func _input(event):
	if not timer_started and event is InputEventKey and event.pressed:
		timer_started = true

func stop_timer():
	timer_started = false

func reset_timer():
	time_elapsed = 0.0
	timer_started = false
	
	if label:
		label.text = "00:00:00"

func format_time(t):
	var minutes = int(t / 60)
	var seconds = int(t) % 60
	var ms = int((t - int(t)) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, ms]
