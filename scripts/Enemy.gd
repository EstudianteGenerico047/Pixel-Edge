extends Area2D


var health = 1000 setget set_health
var death = false

func set_health(value):
	health = value
	$ProgressBar.value = value


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

func on_animation_finished(anim_name: String):
	queue_free()

func take_damage(value):
	if !death:
		var new_health = max(health - value, 0)
		if health > 0:
			set_health(new_health)
		if new_health == 0:
			death = true
			$AnimationPlayer.play("death")
