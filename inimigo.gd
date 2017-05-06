extends KinematicBody2D

export(int, 1, 10) var vida = 1
var vivo = true

func _ready():
	pass
	
func dano(qtde):
	if !vivo:
		return
	vida -= qtde
	print (vida)
	if vida <= 0:
		vivo = false
		get_node("shape").queue_free()
		get_node("anima_andando").stop()
		get_node("anim").play("morre")
		yield(get_node("anim"), "finished")
		queue_free()