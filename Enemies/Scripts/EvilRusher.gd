extends "res://Enemies/Scripts/Enemy.gd"

const HUNT_SPEED = 55
const RUSH_SPEED = 105
const RUSH_DISTANCE = 300

var lastMovingVec = Vector2.RIGHT

func _ready():
	super._ready() # run the parent enemy init
	lastMovingVec = Vector2(cos(rotation), sin(rotation)) # works but feels weird, does godot have a better way? -cdeleon

func _process(delta):
	var distToPlayer = global_position.distance_to(targetPos)
	
	if distToPlayer <= RUSH_DISTANCE:
		lastMovingVec = (targetPos-global_position).normalized();
		global_position += lastMovingVec * delta * RUSH_SPEED
		rotation = lastMovingVec.angle()
	else:
		global_position += lastMovingVec * delta * HUNT_SPEED
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
