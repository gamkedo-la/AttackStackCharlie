extends "res://Enemies/Scripts/Enemy.gd"

const ROTATE_SPEED = 0.2
const CIRCLE_DISTANCE = 350

var circlePercent = 0
var inRangeOfTarget
var targetPos = Vector2()

func _ready():
	var player_node = get_tree().current_scene.get_node("EveryLevelReusedStuff/Player")
	player_node.connect("player_moved", Callable(self, "_on_player_moved"))

func _on_player_moved(new_position):
	targetPos = new_position

func _process(delta):
	var rotationAmount = circlePercent * TAU
	var distToPlayer = global_position.distance_to(targetPos)
	var wasPos = global_position;
	if distToPlayer <= CIRCLE_DISTANCE:
		if inRangeOfTarget == false:
			inRangeOfTarget = true
			var targetSpotOnUnitCircle = (global_position - targetPos).normalized()
			# print("Vector: ")
			# print(targetSpotOnUnitCircle)
			rotationAmount = targetSpotOnUnitCircle.angle()
			# print("Radians: ")
			# print(rotationAmount)
		targetPos.x += cos(rotationAmount + PI/2) * CIRCLE_DISTANCE
		targetPos.y += sin(rotationAmount + PI/2) * CIRCLE_DISTANCE
		global_position += (targetPos - global_position).normalized() * delta * ENEMY_SPEED * 5
	else:
		# print("outofrange")
		inRangeOfTarget = false
		global_position += (targetPos - global_position).normalized() * delta * ENEMY_SPEED * 5
	var moveAng = atan2(global_position.y-wasPos.y,global_position.x-wasPos.x)
	rotation = moveAng
	

	circlePercent += ROTATE_SPEED * delta
	if circlePercent > TAU:
		circlePercent -= TAU
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
