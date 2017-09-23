extends KinematicBody2D

onready var attributes = get_node("Attributes")

const IDLE_SPEED = 10.0

var current_anim = ""

var status
var speed = Vector2()

func _ready():
	status = get_node("Attributes")
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	var dir = Vector2()
	if (Input.is_action_pressed("ui_up")):
		dir += Vector2(0, -1)
	if (Input.is_action_pressed("ui_down")):
		dir += Vector2(0, 1)
	if (Input.is_action_pressed("ui_left")):
		dir += Vector2(-1, 0)
	if (Input.is_action_pressed("ui_right")):
		dir += Vector2(1, 0)
		

	speed = dir.normalized() * attributes.MSPD
	var motion = speed*delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)

	var next_anim = ""
	var next_mirror = false
	
	if (dir == Vector2() and speed.length() < IDLE_SPEED):
		next_anim = "idle"
	elif (speed.length() > IDLE_SPEED*0.1):
		var angle = atan2(abs(speed.x), speed.y)
		
		next_mirror = speed.x > 0
		if (angle < PI/8):
			next_anim = "bottom"
		elif (angle < PI/4 + PI/8):
			next_anim = "bottom_left"
		elif (angle < PI*2/4 + PI/8):
			next_anim = "left"
		elif (angle < PI*3/4 + PI/8):
			next_anim = "top_left"
		else:
			next_anim = "top"
	
	if (next_anim != current_anim):
		#get_node("Anim").play(next_anim)
		current_anim = next_anim
		
