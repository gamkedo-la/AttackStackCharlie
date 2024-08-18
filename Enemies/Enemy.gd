class_name Enemy extends Area2D
var moveDir = Vector2.ZERO;
const ENEMY_SPEED = 50

var exploded = false
var explosion_radius = 500

signal enemy_exploded(position, radius)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	setDirection(Vector2.RIGHT)
	pass

func setDirection(direction: Vector2):
	moveDir = direction

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass

func _on_projectile_detector_area_entered(area):
	if area.is_in_group("bullet"):
		print("enemy exploding")
		queue_free()
