extends "res://Enemies/Scripts/Enemy.gd"

const ROTATE_SPEED_MAX = 0.1
const ROTATE_SPEED_MIN = 0.225
const CIRCLE_DISTANCE_MAX = 270
const CIRCLE_DISTANCE_MIN = 125

var circlePercent = 0
var myOrbitDist = 0
var myOrbitRate = 0
var inRangeOfTarget = false
var cwOrbit = false;

func _ready():
	super._ready() # run the parent enemy init
	cwOrbit = randi_range(0,10) < 5
	myOrbitDist = randf_range(CIRCLE_DISTANCE_MIN,CIRCLE_DISTANCE_MAX)
	myOrbitRate = randf_range(ROTATE_SPEED_MIN,ROTATE_SPEED_MAX)

func _process(delta):
	var rotationAmount = circlePercent * TAU
	var distToPlayer = global_position.distance_to(targetPos)
	var wasPos = global_position;
	
	if inRangeOfTarget || distToPlayer <= myOrbitDist:
		if inRangeOfTarget == false:
			inRangeOfTarget = true
			var targetSpotOnUnitCircle = (global_position - targetPos).normalized()
			var initialAngle = targetSpotOnUnitCircle.angle()
			circlePercent = initialAngle / TAU
			if cwOrbit:
				circlePercent *= -1
		var rotDir = -1;
		if cwOrbit:
			rotDir = 1
		circlePercent += myOrbitRate * delta * rotDir
		global_position.x = targetPos.x + cos(rotationAmount) * myOrbitDist
		global_position.y = targetPos.y + sin(rotationAmount) * myOrbitDist
		rotation = rotationAmount + rotDir * PI/2
	else:
		# print("outofrange")
		global_position += (targetPos - global_position).normalized() * delta * ENEMY_SPEED * 5
		var moveAng = atan2(global_position.y-wasPos.y,global_position.x-wasPos.x)
		rotation = moveAng
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
