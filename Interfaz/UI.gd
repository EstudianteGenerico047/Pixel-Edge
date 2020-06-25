extends Control

var Player1 = Global.player_1
var Player2 = Global.player_2
var P1_life = 0
var P2_life = 0
onready var anim_playerp1 = get_node("AnimationPlayer")
onready var anim_playerp2 = get_node("AnimationPlayer2")
onready var valor_vida_p1 = get_node("p1_lifebar/textura_P1")
onready var valor_vida_p2 = get_node("p2_lifebar/textura_P2")
# Called when the node enters the scene tree for the first time.

func _ready():
	if Player1 < 3:
		print('p1 terrestre')
		anim_playerp1.play("terrestre1")
	else:
		print('p1 alien')
		anim_playerp1.play("alien")
	if Player2 < 3:
		print('p2 terrestre')
		anim_playerp2.play("terrestre2")
	else:
		print('p2 alien')
		anim_playerp2.play("alien2") 
	pass # Replace with function body.

func reiniciar_vida():
	valor_vida_p1.value = 1
	valor_vida_p2.value = 1
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
