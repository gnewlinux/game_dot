extends KinematicBody2D

var divX = 2
var divY = 2

func destroi():
	var reg = get_node("sprite").get_region_rect()
	var tex = get_node("sprite").get_texture()
	var tamX = reg.size.x / divX
	var tamY = reg.size.y / divY
	
	for a in range(divX):
		for l in range(divY):
			var rec = Rect2(reg.pos.x + (tamX * l), reg.pos.y + (tamY * a), tamX, tamY)
			var spr = Sprite.new()
			spr.set_texture(tex)
			spr.set_region(true)
			spr.set_region_rect(rec)
			spr.set_centered(false)
			spr.set_global_pos(get_node("sprite").get_global_pos() + Vector2((tamX * l), (tamY * a)))
			var rig = RigidBody2D.new()
			rig.add_child(spr)
			rig.apply_impulse(Vector2(), Vector2(rand_range(-20,30), rand_range(-20,-80)))
			get_parent().add_child(rig)
	queue_free()