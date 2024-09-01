extends "res://Enemies/Scripts/Enemy.gd"

func _ready():
	pass

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
