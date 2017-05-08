extends KinematicBody2D

var pre_tiro = preload("res://tiro.tscn")
var pre_tiro_e = preload("res://tiro_e.tscn")

export(int, 1, 30) var vida = 1
var vivo = true
var intervalo = 1
var ultimo_toque = 0

func inicio():
	get_node("AnimationPlayer").play("anim")
	pass

func _ready():
	#yield(get_node("AnimationPlayer"), "finished")
	set_process(true)
	pass

func _process(delta):
	var pos = get_pos()
	#print (pos)
	print (ultimo_toque)
	if ultimo_toque > 0:
		ultimo_toque -= delta
	if ultimo_toque < 0.2:
		#get_node("sprite").set_modulate("#ffffff")
		
	
		pass
	
func dano(qtde):
	
	if !vivo:
		return

	if ultimo_toque <= 0:
		vida -= qtde
		ultimo_toque = intervalo
		get_node("dano").play("dano_aranha")
		#get_node("sprite").set_modulate("#fc6363")
		
	
	if vida <= 0:
		vivo = false
		get_node("shape").queue_free()
		get_node("AnimationPlayer").play("morte")
		yield(get_node("AnimationPlayer"), "finished")
		
		queue_free()
	
	pass
	
func tiro():
	var tiro = pre_tiro.instance()
	tiro.set_global_pos(get_node("sprite").get_global_pos())
	get_node("../").add_child(tiro)
	pass
	
func tiro_e():
	var tiro_e = pre_tiro_e.instance()
	tiro_e.set_global_pos(get_node("sprite").get_global_pos())
	get_node("../").add_child(tiro_e)
	pass