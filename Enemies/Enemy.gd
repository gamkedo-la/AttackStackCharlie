class_name Enemy extends Area2D
var moveDir = Vector2.ZERO;
const ENEMY_SPEED = 50

var exploded = false
var explosion_radius = 150
var explosion_area: Area2D = null 

# Called when the node enters the scene tree for the first time.
func _ready():
	setDirection(Vector2.RIGHT)
	explosion_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = explosion_radius
	explosion_area.add_child(collision_shape)
	explosion_area.connect("area_entered", Callable(self, "_on_explosion_area_entered"))
	add_child(explosion_area)
	explosion_area.name = "ExplosionArea"
	explosion_area.set_collision_mask_bit(0, false)
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
	exploded = true
	queue_free()
	if explosion_area and is_instance_valid(explosion_area):
		var overlapping_areas = explosion_area.get_overlapping_areas()
		for area in overlapping_areas:
			if area.is_in_group("hitbox") and area is Enemy and not area.exploded:
				area.get_parent().call_deferred("explode_with_delay")
	else:
		print("DEBUG: Explosion area not found or is invalid.")

func explode_with_delay():
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	explode()
