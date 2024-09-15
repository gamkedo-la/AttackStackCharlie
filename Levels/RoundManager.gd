extends Node

# Add a variable to count defeated enemies.
var defeated_enemies = 0
var level_goal = 10  # This can be set in the Inspector.

func _ready():
	pass

func _on_enemy_defeated():
	# print("enemy removal signal receieved")
	defeated_enemies += 1
	print(str(defeated_enemies) + " enemies defeated")
	# $UI/EnemyCounterLabel.text = str(defeated_enemies)
	if defeated_enemies >= level_goal:
		print("Level won!")
	pass
