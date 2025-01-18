extends CharacterBody2D

@export var rotation_speed_min: float = 45
@export var rotation_speed_max: float = 135

@export var speed_min: float = 50.0
@export var speed_max: float = 150.0

@export var heading_deviation_angle_min: float = 10
@export var heading_deviation_angle_max: float = 30

var border_buffer: float = 10

var speed : float
var rotation_speed: float
var heading : Vector2

var camera_width: float 
var camera_height: float

var topY: float
var bottomY: float
var leftX: float
var rightX: float

# Used to detect when the asteroid leaves the screen
@onready var areaBoundary = get_tree().current_scene.get_node("EveryLevelReusedStuff/Boundaries/BoundaryCollision")

@export var player: Node2D
func _ready():
	var viewport = get_viewport_rect()
	camera_width = viewport.size.x 
	camera_height = viewport.size.y
	
	if is_instance_valid(areaBoundary):
		areaBoundary.connect("body_exited", Callable(self, "on_exited_level_bounds"))
	else:
		push_error("Asteroid: Missing Level area Boundary!")

	topY = border_buffer
	bottomY = camera_height - border_buffer
	leftX = border_buffer
	rightX = camera_width - border_buffer

	init_movement()

func init_movement():
	speed = randf_range(speed_min, speed_max)
	rotation_speed = randf_range(rotation_speed_min, rotation_speed_max)

	# randomize heading
	heading = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
func perturb_heading():
	var angle = randf_range(heading_deviation_angle_min, heading_deviation_angle_max) * ( 1 if randf() <= 0.5 else -1)
	# rotate heading by angle
	heading = heading.rotated(deg_to_rad(angle))
	
	#print("Changed heading")
	
func _process(delta):
	rotation_degrees += rotation_speed * delta
	position += speed * heading * delta

func on_exited_level_bounds(body):
	# This gets called for every body leaving the area. Need to filter to self
	# Maybe there is a better way to filter the notifications?
	if body != self:
		return
		
	# Want to reflect the position of the asteroid so that if it was on bottom re-appears on the top a
	# if on the left, reappears on right going in opposite direction

	#print("Asteroid - " + to_string() +
	 #" exited screen: pos={" + str(position.x) + "," + str(position.y) + "};" +
	 #" heading={" + str(heading.x) + "," + str(heading.y) +"}")
	
	if global_position.x <= leftX:
		global_position.x = rightX
	elif global_position.x >= camera_width - 10:
		global_position.x = leftX
		
	if global_position.y <= topY:
		global_position.y = bottomY
	elif global_position.y >= camera_height - 10:
		global_position.y = topY
	
	# randomize the movement when it comes out the other end
	# Not sure I like fully randomzing it again
	# init_movement()
	# Instead just perturb the heading slightly so it isn't super repetitive
	perturb_heading()
	
	#print("Asteroid - " + to_string() +
	 #" re-appear at pos={" + str(position.x) + "," + str(position.y) + "};" +
	 #" heading={" + str(heading.x) + "," + str(heading.y) +"}")
