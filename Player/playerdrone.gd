extends CharacterBody2D

@export var droneSpritePath: NodePath
@onready var droneSprite = get_node(droneSpritePath) as Node2D

const SPEED = 7.0
const ANGLE_CHANGE = 4
const DISTANCE = 80.0
var current_angle = 0.0
var player_position = Vector2()
var drone_facing = Vector2()

func _ready():
	var player_node = get_node("../Player")  # Adjust the path as necessary
	player_node.connect("player_moved", Callable(self, "_on_player_moved"))
	player_node.connect("player_turned", Callable(self, "_on_player_turned"))

func _on_player_turned(new_facing):
	drone_facing = new_facing
	if drone_facing == Vector2.LEFT:
		droneSprite.rotation = PI
	if drone_facing == Vector2.RIGHT:
		droneSprite.rotation = 0
	if drone_facing == Vector2.UP:
		droneSprite.rotation = -PI/2
	if drone_facing == Vector2.DOWN:
		droneSprite.rotation = PI/2

func _on_player_moved(new_position):
	player_position = new_position

func _physics_process(delta):
	current_angle += delta * ANGLE_CHANGE
	position.x = player_position.x + DISTANCE * cos(current_angle)
	position.y = player_position.y + DISTANCE * sin(current_angle)
	move_and_slide()
