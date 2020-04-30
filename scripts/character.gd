extends KinematicBody2D

var timer = 0.0
var jumpvelocity = 150.0
var gravityscale = 200.0
var anim = ""
var gravity      = 600
var linear_vel = Vector2()
var jump  = -300

export(int) var walk_vel = 150

onready var playback = $AnimationTree.get("parameters/playback")

func _ready():

	pass

func _process(delta):
	pass

func _physics_process(delta):
	
	linear_vel.y +=delta * gravity #gravedad
	linear_vel = move_and_slide(linear_vel, Vector2(0,-1))

	var move_left = Input.is_action_pressed("left")
	var move_right = Input.is_action_pressed("right")
	var jumping = Input.is_action_just_pressed("jump")
	var basic         = Input.is_action_just_pressed("basic_atack")
	var special         = Input.is_action_just_pressed("special_atack")
	var target_vel=Vector2()
	
	var on_floor = is_on_floor()


		
	####################movimientos######################################
	if move_left:
		target_vel.x=-walk_vel
			
	if move_right:
		target_vel.x=walk_vel
		
	if  on_floor:
		if jumping:
			linear_vel.y= jump
			



	linear_vel.x=lerp(linear_vel.x,target_vel.x,0.2)
	
	##########################animacion########################################
	if on_floor and (basic or special):
		if basic:
			playback.travel("atack1")
			linear_vel.x = 0
		if special: 
			playback.travel("atack2")						
			linear_vel.x = 0
	elif on_floor:
		if abs(linear_vel.x) > 10.00:
			playback.travel("Walk")
			if linear_vel.y !=0:
				playback.travel("jump_start")
		elif linear_vel.y !=0:
			playback.travel("jump_start")
		else:
			playback.travel("idle")			
		
	else:
		if linear_vel.y > 0:
			playback.travel("jump_air")
			
		if linear_vel.y==0:
			playback.travel("jump_down")
			

###orientacion espacial


	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		$sprite.scale.x = -1.5
		$Attacks.scale.x = -1
		
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		$sprite.scale.x = 1.5
		$Attacks.scale.x = 1
		
func _on_Continue_pressed():
	pass # Replace with function body.


func _on_Retry_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	pass # Replace with function body.


