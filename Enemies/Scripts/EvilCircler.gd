extends "res://Enemies/Scripts/Enemy.gd"

const ROTATE_SPEED = 0.2
const CIRCLE_DISTANCE = 150

var circlePercent = 0
var inRangeOfTarget
var cwOrbit = false;

func _ready():
	super._ready() # run the parent enemy init
	cwOrbit = randi_range(0,10) < 5

func _process(delta):
	var rotationAmount = circlePercent * TAU
	var distToPlayer = global_position.distance_to(targetPos)
	var wasPos = global_position;
	
	circlePercent += ROTATE_SPEED * delta
	if circlePercent > 1.0:
		circlePercent -= 1.0

	if distToPlayer <= CIRCLE_DISTANCE:
		if inRangeOfTarget == false:
			inRangeOfTarget = true
			var targetSpotOnUnitCircle = (global_position - targetPos).normalized()
			rotationAmount = targetSpotOnUnitCircle.angle()
		var rotDir = -1;
		if cwOrbit:
			rotDir = 1
		global_position.x = targetPos.x + cos(rotationAmount + rotDir*PI/2) * CIRCLE_DISTANCE
		global_position.y = targetPos.y + sin(rotationAmount + rotDir*PI/2) * CIRCLE_DISTANCE
	else:
		# print("outofrange")
		global_position += (targetPos - global_position).normalized() * delta * ENEMY_SPEED * 5
	var moveAng = atan2(global_position.y-wasPos.y,global_position.x-wasPos.x)
	rotation = moveAng	
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
