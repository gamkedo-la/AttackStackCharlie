extends "res://Enemies/Scripts/Enemy.gd"

@export var speed: float = 200.0

func _ready():
	super._ready() # run the parent enemy init
	isJustAShot = true
	pass

func _process(delta):
	moveDir = Vector2(speed, 0).rotated(rotation)
	position += moveDir * delta
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
