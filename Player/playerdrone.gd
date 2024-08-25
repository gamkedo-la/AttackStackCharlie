extends CharacterBody2D

const SPEED = 7.0
const ANGLE_CHANGE = 4
const DISTANCE = 80.0
var current_angle = 0.0
var player_position = Vector2()

func _ready():
	var player_node = get_node("../Player")  # Adjust the path as necessary
	player_node.connect("player_moved", Callable(self, "_on_player_moved"))

func _on_player_moved(new_position):
	player_position = new_position

func _physics_process(delta):
	current_angle += delta * ANGLE_CHANGE
	position.x = player_position.x + DISTANCE * cos(current_angle)
	position.y = player_position.y + DISTANCE * sin(current_angle)
	move_and_slide()
