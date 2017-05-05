
extends KinematicBody2D

# This is a simple collision demo showing how
# the kinematic controller works.
# move() will allow to move the node, and will
# always move it to a non-colliding spot,
# as long as it starts from a non-colliding spot too.

# Member variables
const GRAVITY = 500.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 100
const STOP_FORCE = 1300
const JUMP_SPEED = 230
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # One pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var nova_anim = ""
var animacao = ""
var estava_chao = false
var empurra_forca = Vector2(30,0)

func _fixed_process(delta):
	randomize()
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	var stop = true
	
	if (walk_left):
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			force.x -= WALK_FORCE
			stop = false
	elif (walk_right):
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			force.x += WALK_FORCE
			stop = false
	
	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0
		
		velocity.x = vlen*vsign
	
	# Integrate forces to velocity
	velocity += force*delta
	
	# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	motion = move(motion)
	
	var floor_velocity = Vector2()
	
	if (is_colliding()):
		# You can check which tile was collision against with this
		# print(get_collider_metadata())
		
		# Ran against something, is it the floor? Get normal
		var n = get_collision_normal()
		
		if (rad2deg(acos(n.dot(Vector2(0, -1)))) < FLOOR_ANGLE_TOLERANCE):
			# If angle to the "up" vectors is < angle tolerance
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
			# Since this formula will always slide the character around, 
			# a special case must be considered to to stop it from moving 
			# if standing on an inclined floor. Conditions are:
			# 1) Standing on floor (on_air_time == 0)
			# 2) Did not move more than one pixel (get_travel().length() < SLIDE_STOP_MIN_TRAVEL)
			# 3) Not moving horizontally (abs(velocity.x) < SLIDE_STOP_VELOCITY)
			# 4) Collider is not moving
			
			revert_motion()
			velocity.y = 0.0
		else:
			# For every other case of motion, our motion was interrupted.
			# Try to complete the motion by "sliding" by the normal
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			move(motion)
	
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)
	
	if (jumping and velocity.y > 0):
		# If falling, no longer jumping
		jumping = false
	
	if (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping): #posso pular?
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		pula()
	
	on_air_time += delta
	prev_jump_pressed = jump

	var chao = get_node("rayChao").is_colliding() || get_node("rayChao1").is_colliding() || get_node("rayChao2").is_colliding()

	if chao && !estava_chao:
		get_node("animFX").play("caiu")
		pass
		
	estava_chao = chao

	var andando = walk_right || walk_left
	
	if andando:
		if velocity.x > 0:
			get_node("sprite").set_flip_h(false)
		else:
			get_node("sprite").set_flip_h(true)
	
	if chao:
		if !jumping:
			velocity.y = 30
		if andando:
			nova_anim = "walking"
			#print("pulo")
		else:
			nova_anim = "stopped"
		
		get_node("empurraD").set_enabled(walk_right)
		get_node("empurraE").set_enabled(walk_left)
		
		if get_node("empurraD").is_colliding():
			var body = get_node("empurraD").get_collider()
			body.move(empurra_forca * delta)
			
		if get_node("empurraE").is_colliding():
			var body = get_node("empurraE").get_collider()
			body.move(empurra_forca * -delta)
		
	else:
		if velocity.y < 0:
			nova_anim = "jumping"
		else:
			nova_anim = "falling"


	if animacao != nova_anim:
		get_node("anim").play(nova_anim)
		animacao = nova_anim
	
	#print(chao)

func pula():
	get_node("animFX").play("pulou")
	velocity.y = -JUMP_SPEED
	jumping = true
	
func pula_alto():
	get_node("animFX").play("pulou")
	velocity.y = -400
	jumping = true

func _ready():
	set_fixed_process(true)

func _on_pes_body_enter( body ):
	pula()
	body.dano(3)


func _on_cabeca_body_enter( body ):
	if body.has_method("destroi"):
		body.destroi()


func _on_Area2D_body_enter( body ):
	print("Fim de jogo!")
	get_tree().change_scene("game.tscn")
	pass # replace with function body


func _on_direita_body_enter( body ):
	print("Tocou Direita")
	#get_node("sprite").hide()
	get_tree().change_scene("game.tscn")
	pass # replace with function body


func _on_esquerda_body_enter( body ):
	print("Tocou Esquerda")
	#get_node("sprite").hide()
	get_tree().change_scene("game.tscn")
	pass # replace with function body


func _on_Area2D_2_body_enter( body ):
	pula_alto()
	pass # replace with function body
