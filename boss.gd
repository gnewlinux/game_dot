extends KinematicBody2D

var pre_tiro = preload("res://tiro.tscn")
var pre_tiro_e = preload("res://tiro_e.tscn")

export(int, 1, 30) var vida = 1
var vivo = true
var vel = 100
var intervalo = 1
var ultimo_toque = 0
var fim = 100
var inicio = 1

func _ready():
	yield(get_node("AnimationPlayer"), "finished")
	get_node("AnimationPlayer").play("anim")
	set_process(true)
	pass

func _process(delta):
	var pos = get_pos()
	#print (pos)
	
	if ultimo_toque > 0:
		#print (ultimo_toque)
		ultimo_toque -= delta
	if ultimo_toque <= 0.1:
		
		get_node("sprite").set_opacity(100)
	
#	if pos.x >= 389:
#		set_scale(Vector2(1,1))
#		set_pos(get_pos() - Vector2(1,0) * vel * delta)
#		var esquerda = true
#	elif pos.x <= 390:
#		set_scale(Vector2(-1,1))
#		set_pos(get_pos() + Vector2(2,0) * vel * delta)
	
	pass
	
func dano(qtde):
	
	if !vivo:
		return

	if ultimo_toque <= 0:
		vida -= qtde
		ultimo_toque = intervalo
		#print(ultimo_toque)
		get_node("sprite").set_opacity(0)
		print (vida)
		
	
	if vida <= 0:
		vivo = false
		get_node("shape").queue_free()
		get_node("AnimationPlayer").play("morte")
		yield(get_node("AnimationPlayer"), "finished")
		#get_node("anima_andando").stop()
		#get_node("anim").play("inicio")
		
		queue_free()
	
	pass
	
func tiro():
	#print("tiro")
	var tiro = pre_tiro.instance()
	tiro.set_global_pos(get_node("sprite").get_global_pos())
	get_node("../").add_child(tiro)
	pass
	
func tiro_e():
	#print("tiro2")
	var tiro_e = pre_tiro_e.instance()
	tiro_e.set_global_pos(get_node("sprite").get_global_pos())
	get_node("../").add_child(tiro_e)
	pass