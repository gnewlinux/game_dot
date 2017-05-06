extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	get_node("anim").stop()
	pass

func _process(delta):

	pass

func _on_Area2D_3_body_enter( body ):
	get_node("anim").play("caindo")
	get_node("shape").queue_free()
	pass # replace with function body
