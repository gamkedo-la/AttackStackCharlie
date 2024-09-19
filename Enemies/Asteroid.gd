extends CharacterBody2D

var rotation_speed = 90

func _process(delta):
	rotation_degrees += rotation_speed * delta
