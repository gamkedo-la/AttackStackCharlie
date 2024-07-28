class_name Enemy extends Area2D
var moveDir = Vector2.ZERO;
const ENEMY_SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	setDirection(Vector2.RIGHT)
	pass

func setDirection(direction: Vector2):
	moveDir = direction

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass

func _on_projectile_detector_area_entered(area):
	print('Hit')
	queue_free()
	pass # Replace with function body.
