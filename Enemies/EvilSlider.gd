extends "res://Enemies/Enemy.gd"

func _ready():
	pass

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass
