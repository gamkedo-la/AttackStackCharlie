extends CharacterBody2D

var rotation_speed = 90
@export var speed: float = 100.0

var camera_width: float 
var camera_height: float 


@export var player: Node2D
func _ready():
	var viewport = get_viewport_rect()
	camera_width = viewport.size.x 
	camera_height = viewport.size.y
	
	if randf_range(0, 100) < 50:
		speed = -speed
	
	# position.x = -50
	# position.y = randf_range(0, camera_height)
	var sprite = $AnimatedSprite2D

func _process(delta):
	rotation_degrees += rotation_speed * delta
	position.x += speed * delta
	
	if position.x < 10:
		respawn_on_right()
	if position.x > camera_width - 10:
		respawn_on_left()
	
	
func respawn_on_left():
	position.x = 15
	position.y = randf_range(0, camera_height)

func respawn_on_right():
	position.x = camera_width - 15
	position.y = randf_range(0, camera_height)
