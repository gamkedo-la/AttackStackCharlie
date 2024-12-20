extends "res://Enemies/Scripts/Enemy.gd"

const ROTATE_SPEED_MIN = 0.07
const ROTATE_SPEED_MAX = 0.245
const CIRCLE_DISTANCE_MAX = 230
const CIRCLE_DISTANCE_MIN = 100
const ARRIVE_AT_DIST_MIN = 50
const ARRIVE_AT_DIST_MAX = 150
const ARRIVE_AT_SPEED_MULT = 2
const ENEMY_SPEED_SEEK_SPEED_MULT = 5

var circlePercent = 0
var myOrbitDist = 0
var myOrbitRate = 0
var myArriveAtDist = 0

var inRangeOfTarget = false
var cwOrbit = false;
var rotDir = 0

func _ready():
	super._ready() # run the parent enemy init
	cwOrbit = randi_range(0,10) < 5
	myOrbitDist = randf_range(CIRCLE_DISTANCE_MIN,CIRCLE_DISTANCE_MAX)
	myOrbitRate = randf_range(ROTATE_SPEED_MIN,ROTATE_SPEED_MAX)
	myArriveAtDist = randf_range(ARRIVE_AT_DIST_MIN,ARRIVE_AT_DIST_MAX)
	rotDir = -1 if cwOrbit else 1

func _process(delta):
	#print("global_position=" + str(global_position) + "circlePercent=" + str(circlePercent) + ";rotation=" + str(rotation))
	
	var distToPlayer = global_position.distance_to(targetPos)
	var wasPos = global_position;
	
	if inRangeOfTarget || distToPlayer <= myOrbitDist:
		if inRangeOfTarget == false:
			inRangeOfTarget = true
			# We are arriving at the target and want to start orbiting from the current position
			# Convert from cartesian to polar coordinates which just involves calculating the central angle
			var initialAngle = atan2(global_position.y-targetPos.y, global_position.x-targetPos.x)
			circlePercent = initialAngle / TAU
			return
		
		circlePercent += myOrbitRate * delta * rotDir
		var rotationAmount = circlePercent * TAU

		global_position.x = targetPos.x + cos(rotationAmount) * myOrbitDist
		global_position.y = targetPos.y + sin(rotationAmount) * myOrbitDist
		rotation = rotationAmount + rotDir * PI/2
	else:
		# print("outofrange")
		global_position += (targetPos - global_position).normalized() * delta * calculate_speed(distToPlayer)
		var moveAng = atan2(global_position.y-wasPos.y,global_position.x-wasPos.x)
		rotation = moveAng
	pass

func calculate_speed(distToPlayer):
	var circlingDist = distToPlayer - myOrbitDist
	var seekSpeed = float(ENEMY_SPEED_SEEK_SPEED_MULT * ENEMY_SPEED)
	if circlingDist >= myArriveAtDist:
		return seekSpeed

	# Arrive at circling speed smoothly
	# v = r * w
	var orbitTranslationalSpeed = myOrbitDist * myOrbitRate
	var lerpedSpeed = lerp(orbitTranslationalSpeed * ARRIVE_AT_SPEED_MULT, seekSpeed, circlingDist / myArriveAtDist)
	
	# print("speed=" + str(lerpedSpeed) + "orbitSpeed=" + str(orbitTranslationalSpeed) + "seekSpeed=" + str(seekSpeed) + ";alpha=" + str(circlingDist / myArriveAtDist))
	return lerpedSpeed
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
