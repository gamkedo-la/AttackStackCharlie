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
	var explosion_manager = get_node_or_null("/root/ExplosionManager")
	if explosion_manager:
		connect("enemy_exploded", Callable(explosion_manager, "trigger_explosion_at_position"))
	else:
		print("ERROR: ExplosionManager not found :(")
	var explosion_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = explosion_radius
	explosion_area.add_child(collision_shape)
	add_child(explosion_area)
	explosion_area.set_collision_layer_bit(1, true)
	explosion_area.set_collision_mask_bit(1, true)
	explosion_area.add_to_group("explosion_areas")
	pass

func setDirection(direction: Vector2):
	moveDir = direction

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass

func _on_projectile_detector_area_entered(area):
	if area.is_in_group("bullet") and not exploded:
		explode()

func explode():
	print("enemy exploding")
	emit_signal("enemy_exploded", global_position, explosion_radius)
	queue_free()

func explode_with_delay():
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	explode()
