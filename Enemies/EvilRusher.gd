extends "res://Enemies/Enemy.gd"

@export var rusherSpritePath: NodePath
@onready var rusherSprite = get_node(rusherSpritePath) as Node2D

const HUNT_SPEED = 25
const RUSH_SPEED = 95
const RUSH_DISTANCE = 200

var targetPos = Vector2()
var lastMovingVec = Vector2.RIGHT

func _ready():
	var player_node = get_tree().current_scene.get_node("Player")
	player_node.connect("player_moved", Callable(self, "_on_player_moved"))

func _on_player_moved(new_position):
	targetPos = new_position

func _process(delta):
	var distToPlayer = global_position.distance_to(targetPos)
	
	if distToPlayer <= RUSH_DISTANCE:
		lastMovingVec = (targetPos-global_position).normalized();
		global_position += lastMovingVec * delta * RUSH_SPEED
		rusherSprite.rotation = lastMovingVec.angle()
	else:
		global_position += lastMovingVec * delta * HUNT_SPEED
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass