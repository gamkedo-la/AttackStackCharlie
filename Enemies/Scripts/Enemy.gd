class_name Enemy extends Area2D
var moveDir = Vector2.ZERO;
const ENEMY_SPEED = 50

var exploded = false
var explosion_radius = 500

var explosion_scene = preload("res://Explosions/EnemyBlast.tscn")
signal enemy_exploded(position, radius)

func _ready():
	add_to_group("enemies")
	setDirection(Vector2.RIGHT)
	pass

func setDirection(direction: Vector2):
	moveDir = direction

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass

func destroy():
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	get_tree().root.call_deferred("add_child", explosion) 
	queue_free()

func _on_projectile_detector_area_entered(area):
	if area.is_in_group("bullet"):
		destroy()
