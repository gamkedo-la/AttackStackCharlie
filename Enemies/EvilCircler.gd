extends "res://Enemies/Enemy.gd"

const ROTATE_SPEED = 0.2
const CIRCLE_DISTANCE = 300

var playerPos
var circlePercent = 0
var inRangeOfTarget

func _ready():
	pass

func _process(delta):
	var playerCenter = get_parent().get_parent().get_node("Player").get_node("CollisionShape2D").get_shape().get_rect().get_center()
	playerPos = get_parent().get_parent().get_node("Player").global_position
	var rotationAmount = circlePercent * TAU
	var targetPos = playerPos + playerCenter
	var distToPlayer = global_position.distance_to(targetPos)
	if distToPlayer <= CIRCLE_DISTANCE:
		if inRangeOfTarget == false:
			inRangeOfTarget = true
			var targetSpotOnUnitCircle = (global_position - targetPos).normalized()
			print("Vector: ")
			print(targetSpotOnUnitCircle)
			rotationAmount = targetSpotOnUnitCircle.angle()
			print("Radians: ")
			print(rotationAmount)
		targetPos.x += cos(rotationAmount + PI/2) * CIRCLE_DISTANCE
		targetPos.y += sin(rotationAmount + PI/2) * CIRCLE_DISTANCE
		global_position += (targetPos - global_position).normalized() * delta * ENEMY_SPEED * 5
	else:
		print("outofrange")
		inRangeOfTarget = false
		global_position += (targetPos - global_position).normalized() * delta * ENEMY_SPEED * 5
	

	circlePercent += ROTATE_SPEED * delta
	if circlePercent > TAU:
		circlePercent -= TAU
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
