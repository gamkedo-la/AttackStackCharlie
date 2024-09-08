extends Node3D

@export var spinPace: float = 1.0
@export var horizAffect: float = 1.0
@export var vertAffect: float = 1.0

func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	rotation.x = cos(time * spinPace+horizAffect*position.x)
	rotation.y = cos(time * spinPace+vertAffect*position.y)
