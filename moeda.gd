extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_moeda_body_enter( body ):
	if body.get_layer_mask() == 1:
		get_node("anim").play("collect")
		get_node("shape").queue_free()
		yield(get_node("anim"), "finished")
		queue_free()
	
	pass # replace with function body
