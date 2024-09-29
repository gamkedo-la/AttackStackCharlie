class_name Enemy extends Area2D
var moveDir = Vector2.ZERO;
const ENEMY_SPEED = 50

var exploded = false
var explosion_radius = 500

var explosion_scene = preload("res://Explosions/EnemyBlast.tscn")
signal enemy_exploded(position, radius)

signal enemy_defeated()

var powerup_paths = [
    "res://Powerups/UpgradeShot_Range.tscn",
    "res://Powerups/UpgradeShot_ROF.tscn",
    "res://Powerups/UpgradeShot_Split.tscn",
    "res://Powerups/Upgrade_AddDrone.tscn"
]

var powerup_spawn_counts = {}

func _ready():
	for path in powerup_paths:
		powerup_spawn_counts[path] = 0
	add_to_group("enemies")
	var roundManagerNode = get_tree().current_scene.get_node("EveryLevelReusedStuff")	
	if roundManagerNode:
		connect("enemy_defeated", Callable(roundManagerNode, "_on_enemy_defeated"))
	else:
		print("Can't find roundManagerNode for signal")
	# print("enemy signal registering")
	setDirection(Vector2.RIGHT)
	pass

func setDirection(direction: Vector2):
	moveDir = direction

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass


func destroy():
	try_spawn_powerup()
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	get_tree().root.call_deferred("add_child", explosion) 
	emit_signal("enemy_defeated")
	# print("enemy signal sending")
	queue_free()

func _on_projectile_detector_area_entered(area):
	if area.is_in_group("bullet"):
		destroy()

func try_spawn_powerup():
	if randf() < 0.25:
		spawn_powerup()

func sum_array(values):
	var total = 0.0
	for value in values:
		total += value
	return total

func spawn_powerup():
	var total = sum_array(powerup_spawn_counts.values()) + 1
	var weights = []
	for path in powerup_paths:
		var count = powerup_spawn_counts[path]
		weights.append(1.0 / (count + 1))
	var weight_sum = sum_array(weights)
	for i in range(weights.size()):
		weights[i] = weights[i] / weight_sum
	var random_pick = randf()
	var accum = 0.0
	var index = 0
	for weight in weights:
		accum += weight
		if random_pick < accum:
			break
		index += 1
	var powerup_scene = load(powerup_paths[index])
	var powerup_instance = powerup_scene.instantiate()
	get_parent().call_deferred("add_child", powerup_instance)
	powerup_instance.global_position = global_position
	powerup_spawn_counts[powerup_paths[index]] += 1 # so we can later lower odds of repeats
