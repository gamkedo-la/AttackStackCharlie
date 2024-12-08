extends "res://Enemies/Scripts/Enemy.gd"

const SPIKE_SLIDE_SPEED = 35.0

func _ready():
	#note: next setting also means shooting a mine won't chain react!
	isJustAShot = true # spikes don't count to win stage (note: homing spikes do)
	super._ready() # run the parent enemy init
	pass

func _process(delta):
	moveDir = (targetPos-global_position).normalized();
	position += moveDir * SPIKE_SLIDE_SPEED * delta
	pass
