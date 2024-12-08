extends "res://Enemies/Scripts/Enemy.gd"

const MINE_SLIDER_SPEED = 180.0

func _ready():
	super._ready() # run the parent enemy init
	pass

func _process(delta):
	moveDir = Vector2(MINE_SLIDER_SPEED, 0).rotated(rotation)
	position += moveDir * delta
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
