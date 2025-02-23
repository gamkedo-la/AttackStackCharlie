class_name Enemy extends Area2D
var moveDir = Vector2.ZERO
const ENEMY_SPEED = 50
const DROP_PERC = 0.3

# used because shots are based on enemies. if true it:
# won't ever drop powerups
# won't chain react explode
# won't fire its own shots
# won't use the enemy_defeated signal for stats/victory
# note: will still destruct if shot, gets ereased in chain react blast
# note: probably could be refactored in a more separate way, for now this works
var isJustAShot = false

# the next value should be an enum or something, but didn't want to
# just fall back on my old C/JS const approach, can clean it up later
var shotBasic
@export var projectileMode: int = 1 # 0 no, 1 straight ahead, 2 toward player, 3 mine layer
@export var reloadTime: float = 1.0
@export var fire_dist: float = 250.0
@export var shotType: String = "EvilShot"

var exploded = false
var explosion_radius = 500

var explosion_scene = preload("res://Explosions/EnemyBlast.tscn")
signal enemy_exploded(position, radius)

signal enemy_defeated()

var powerup_spawn_counts = {}

var targetPos = Vector2()

@onready var criticalDangerFeedback = get_tree().current_scene.get_node("EveryLevelReusedStuff/CriticalDangerFeedback")

func fire_reload_loop_after_rand_delay():
	var timer = get_tree().create_timer(reloadTime * randf_range(0.2,1.0))
	await timer.timeout
	fire_reload_loop()

func fire_reload_loop():
	while true:
		var distToPlayer = global_position.distance_to(targetPos)
		if distToPlayer <= fire_dist:
			if get_tree().paused == false:
				fire_shot()
		var timer = get_tree().create_timer(reloadTime)
		await timer.timeout

func fire_shot():
	var shot = shotBasic.instantiate()
	get_tree().root.add_child(shot)
	if projectileMode == 1:
		shot.rotation = rotation
	if projectileMode == 2:
		var toPlayer = (targetPos-global_position).normalized()
		shot.rotation = toPlayer.angle()
	# doesn't matter for mine layer / projectileMode == 3
	shot.global_position = position

func _on_player_moved(new_position):
	targetPos = new_position

func _ready():
	var player_node = get_tree().current_scene.get_node("EveryLevelReusedStuff/Player")
	if player_node:
		player_node.connect("player_moved", Callable(self, "_on_player_moved"))
	if projectileMode != 0 && isJustAShot == false:
		shotBasic = load("res://Enemies/"+shotType+".tscn")
		fire_reload_loop_after_rand_delay()
		add_to_group("enemies")
	else:
		add_to_group("enemy_shots")
	for powerup in PlayerVars.powerup_paths:
		powerup_spawn_counts[powerup["path"]] = 0
	var roundManagerNode = get_tree().current_scene.get_node("EveryLevelReusedStuff")	
	if roundManagerNode:
		if isJustAShot==false:
			connect("enemy_defeated", Callable(roundManagerNode, "_on_enemy_defeated"))
	else:
		print("Can't find roundManagerNode for signal")

	if criticalDangerFeedback:
		connect("enemy_defeated", Callable(criticalDangerFeedback, "on_enemy_defeated"))
	else:
		print("Can't find criticalDangerFeedback for signal")

	# print("enemy signal registering")
	# setDirection(Vector2.RIGHT)
	pass

func setDirection(direction: Vector2):
	moveDir = direction

func _process(delta):
	position += moveDir * delta * ENEMY_SPEED
	pass

func destroy(blastDepth = 1):
	if isJustAShot == false:
		try_spawn_powerup()
		var explosion = explosion_scene.instantiate()
		explosion.position = position
		explosion.blastDepth = blastDepth # increased by 1 from where destroy is called
		PlayerVars.increase_stat_if_increased("chain_reaction_depth",blastDepth,false)
		get_tree().root.call_deferred("add_child", explosion) 
		emit_signal("enemy_defeated")
	# print("enemy signal sending")
	queue_free()

func force_safe_remove():
	queue_free()

func _on_projectile_detector_area_entered(area):
	if area.is_in_group("bullet"):
		destroy(1)

func try_spawn_powerup():
	if randf() < DROP_PERC:
		spawn_powerup()

func sum_array(values):
	var total = 0.0
	for value in values:
		total += value
	return total

func spawn_powerup():
	var total = sum_array(powerup_spawn_counts.values()) + 1
	var weights = []
	for powerup in PlayerVars.powerup_paths:
		var count = powerup_spawn_counts[powerup["path"]]
		if PlayerVars.check_perhit_stat(powerup["stat"]) >= powerup["minimum"]:
			weights.append(1.0 / (count + 1))
		else:
			weights.append(0.0)
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
	var powerup_scene = load(PlayerVars.powerup_paths[index]["path"])
	PlayerVars.reset_stat(PlayerVars.powerup_paths[index]["stat"])
	var powerup_instance = powerup_scene.instantiate()
	get_parent().call_deferred("add_child", powerup_instance)
	powerup_instance.global_position = global_position
	powerup_spawn_counts[PlayerVars.powerup_paths[index]["path"]] += 1 # so we can later lower odds of repeats
