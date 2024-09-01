extends "res://Enemies/Scripts/Enemy.gd"

const HUNT_SPEED = 55
const RUSH_SPEED = 105
const RUSH_DISTANCE = 300

var targetPos = Vector2()
var lastMovingVec = Vector2.RIGHT

func _ready():
	var player_node = get_tree().current_scene.get_node("EveryLevelReusedStuff/Player")
	player_node.connect("player_moved", Callable(self, "_on_player_moved"))
	lastMovingVec = Vector2(cos(rotation), sin(rotation)) # works but feels weird, does godot have a better way? -cdeleon

func _on_player_moved(new_position):
	targetPos = new_position

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
