extends Node

var timeAlive = 0.7

func _physics_process(delta):
	timeAlive -= delta
	if timeAlive < 0:
		queue_free()
