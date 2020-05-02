extends KinematicBody2D



var jumpvelocity = 150.0
var gravityscale = 200.0
var anim = ""
var gravity      = 600
var linear_vel = Vector2()
var jump  = -300

# Variables relacionadas con deteccion de combo ###################
var timer= null
var max_streak_delay = 1.1
var streak1= 0 setget set_streak
var on_combo=false  #aun no tiene uso
var new_streak=0
var multiplier=1 #hay q definir la función multiplier

################################################################
var ded=false
var health = 1001 setget set_health
var helt = null
var death = false setget on_dead

export(int) var walk_vel = 150

onready var playback = $AnimationTree.get("parameters/playback")




func set_health(value):
	playback.travel("hurt")
	health=value	
	$HealthBar.value = value
	if health < 0.0:
		print("ded")
		var death=true
	print(health)
	
func on_dead(value):
	if value==true:
		playback.travel("ded")
		set_physics_process(false)
		
func _ready():
####### Construccion del timer
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(max_streak_delay)
	timer.connect("timeout",self,"on_timeout_complete")
	add_child(timer)

	$Attacks.connect("area_entered", self, "on_enemy_entered")
	
func on_timeout_complete():  #tiempo expirado
	on_combo=false
	set_streak(0)
	
func on_enemy_entered(Attacks: Area2D):
	if Attacks.is_in_group("Enemy"):
		if playback.get_current_node()=="Finisher":  #caso de lanzar el finisher 
			if streak1<3:									#El combo es muy bajo
				helt=health-(20*rand_range(1,14))
				set_health(helt)
			if streak1>2: 
				Attacks.take_damage(30*streak1)#cambiar streak1 por multiplier cuando este listo
			
		else: 
			Attacks.take_damage(20)
		#inicio/reinicio timer
			timer.start()
			new_streak=(streak1 +1)
			set_streak(new_streak)



######## Barra de carga del combo			
func set_streak(value):
	print(streak1)
	streak1=value
	$StreakBar.value = value	

			
		
func _process(delta):
	pass


func _physics_process(delta):
	
	linear_vel.y +=delta * gravity #gravedad
	linear_vel = move_and_slide(linear_vel, Vector2(0,-1))
	
	var move_left    = Input.is_action_pressed("left")
	var move_right   = Input.is_action_pressed("right")
	var jumping      = Input.is_action_just_pressed("jump")
	var basic        = Input.is_action_just_pressed("basic_atack")
	var special      = Input.is_action_just_pressed("special_atack")
	var finisher     = Input.is_action_just_pressed("finisher_atack")
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
	if on_floor and (basic or special or finisher):
		if basic:
			playback.travel("atack1")
			linear_vel.x = 0
			
		if special: 
			playback.travel("atack2")
			linear_vel.x = 0
		if finisher:
			playback.travel("Finisher")
			linear_vel.x = 0
			
	elif on_floor:
		if Input.is_action_just_pressed("ui_end"):   #Hacerse la suicidación
			playback.travel("hurt")
			helt=health-100
			set_health(helt)
			
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
