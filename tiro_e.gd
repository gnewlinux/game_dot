extends Node2D

var vel = 50
var rot = -180

func _ready():
	set_process(true)
	rotate(rot)
	pass

func _process(delta):
	# seta animacao de movimento
	
	set_pos(get_pos() + Vector2(2,-2) * vel * delta)
	if get_pos().y < -80:
#		print("saiu")
		queue_free()
		pass
	
	pass
