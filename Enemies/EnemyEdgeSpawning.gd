extends Node2D

var enemy_scene = preload("res://Enemies/EvilSlider.tscn")
var max_enemies = 5

func _ready():
	spawn_loop()

func spawn_loop():
	while true:
		var delay_time = randf_range(0.25, 0.75)
		var timer = get_tree().create_timer(delay_time)
		await timer.timeout
		if get_node_count() < max_enemies:
			spawn_enemy_at_random_edge()

func get_node_count():
	return get_tree().get_nodes_in_group("enemies").size()

func spawn_enemy_at_random_edge():
	var viewport_size = get_viewport_rect().size

	# Randomly select an edge: 0 = top, 1 = bottom, 2 = left, 3 = right
	var edge = randi() % 4
	var spawn_position = Vector2()
	var enemy = enemy_scene.instantiate()
	match edge:
		0: # Top
			enemy.setDirection(Vector2.DOWN)
			enemy.rotation = -PI / 2
			spawn_position = Vector2(randf() * viewport_size.x, 0)
		1: # Bottom
			enemy.setDirection(Vector2.UP)
			enemy.rotation = PI / 2
			spawn_position = Vector2(randf() * viewport_size.x, viewport_size.y)
		2: # Left
			enemy.setDirection(Vector2.RIGHT)
			enemy.rotation = PI
			spawn_position = Vector2(0, randf() * viewport_size.y)
		3: # Right
			enemy.setDirection(Vector2.LEFT)
			enemy.rotation = 0
			spawn_position = Vector2(viewport_size.x, randf() * viewport_size.y)
	enemy.global_position = spawn_position
	enemy.add_to_group("enemies")
	get_tree().root.add_child(enemy)
