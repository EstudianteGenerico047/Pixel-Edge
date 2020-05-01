extends Node

var combo = 0 setget set_hits
var death = false

func set_hits(value):
	combo = value
	$ProgressBar.value = value
	
