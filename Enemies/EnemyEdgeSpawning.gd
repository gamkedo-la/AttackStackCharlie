extends Node2D

@export var enemy_data: Array[Dictionary] = [
	{"scene": "EvilRusher", "weight": 1},
	{"scene": "EvilSlider", "weight": 3},
	{"scene": "EvilCircler", "weight": 2}
]
@export var minRespawnTime: float = 0.25
@export var maxRespawnTime: float = 0.75
@export var maxEnemies: int = 25
@export var spawning_active: bool = true;


func _ready():
	spawn_loop()

func spawn_loop():
	while spawning_active && get_tree() != null:
		var delay_time = randf_range(minRespawnTime, maxRespawnTime)
		var timer = get_tree().create_timer(delay_time)
		await timer.timeout
		if get_node_count() < maxEnemies:
			spawn_enemy_at_random_edge()
			
func toggle_spawning():
	spawning_active = !spawning_active;

func get_node_count():
	if (get_tree() == null):
		return 0;
		
	return get_tree().get_nodes_in_group("enemies").size()

func get_spawn_weight_total():
	var total_weight = 0
	for data in enemy_data:
		total_weight += data["weight"]
	return total_weight

func load_scene(scene_name: String):
	var scene_path = "res://Enemies/" + scene_name + ".tscn"
	return load(scene_path)
		
func select_enemy_scene():
	var total_weight = get_spawn_weight_total()
	var random_value = randi() % total_weight
	var current_weight = 0

	for data in enemy_data:
		current_weight += data["weight"]
		if random_value < current_weight:
			return load_scene(data["scene"])

	print("I messed up the spawn ratio logic this should not be seen - cdeleon");
	return null

func spawn_enemy_at_random_edge():
	if (get_tree() == null):
		return;
		
	var viewport_size = get_viewport_rect().size

	# Randomly select an edge: 0 = top, 1 = bottom, 2 = left, 3 = right
	var edge = randi() % 4
	var spawn_position = Vector2()
	var enemy = select_enemy_scene().instantiate()
	match edge:
		0: # Top
			enemy.setDirection(Vector2.DOWN)
			enemy.rotation = PI / 2
			spawn_position = Vector2(randf() * viewport_size.x, 0)
		1: # Bottom
			enemy.setDirection(Vector2.UP)
			enemy.rotation = -PI / 2
			spawn_position = Vector2(randf() * viewport_size.x, viewport_size.y)
		2: # Left
			enemy.setDirection(Vector2.RIGHT)
			enemy.rotation = 0
			spawn_position = Vector2(0, randf() * viewport_size.y)
		3: # Right
			enemy.setDirection(Vector2.LEFT)
			enemy.rotation = PI
			spawn_position = Vector2(viewport_size.x, randf() * viewport_size.y)
	enemy.global_position = spawn_position
	enemy.add_to_group("enemies")
	get_tree().root.add_child(enemy)
