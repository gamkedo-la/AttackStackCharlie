extends Node

# Add a variable to count defeated enemies.
var defeated_enemies = 0
@export var level_goal = 30
@onready var enemy_kill_counter = $EnemyKillCounter
@onready var victory_text = $VictoryText

func _ready():
	victory_text.visible = false;
	enemy_kill_counter.text = str(defeated_enemies) + "/" + str(level_goal);
	pass

func _on_enemy_defeated():
	defeated_enemies += 1
	
	enemy_kill_counter.text = str(defeated_enemies) + "/" + str(level_goal);
	
	if defeated_enemies >= level_goal:
		victory_text.visible = true;
	pass
