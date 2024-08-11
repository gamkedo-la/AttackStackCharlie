extends Node

func trigger_explosion_at_position(position, radius):
	print("Received explosion trigger at: ", position, " with radius: ", radius)
	var affected_areas = get_tree().get_nodes_in_group("explosion_areas")
	for area in affected_areas:
		if area.global_position.distance_to(position) <= radius and area.get_parent().is_in_group("enemies") and not area.get_parent().exploded:
			area.get_parent().explode()

func explode_enemy(enemy):
	enemy.explode()
	emit_signal("enemy_exploded", enemy.global_position, enemy.explosion_radius)
