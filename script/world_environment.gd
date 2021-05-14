extends Node

export(float) var day_time

func _ready():
	pass

func _process(delta):
	day_night_cycle(delta)
	
func day_night_cycle(delta):
	get_parent().get_node("DirectionalLight").rotate_x(delta * day_time)
