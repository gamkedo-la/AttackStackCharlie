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
	
func _process(delta):
	if defeated_enemies >= level_goal:
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.destroy()
		for shot in get_tree().get_nodes_in_group("shots"):
			shot.destroy()
		for enemyshot in get_tree().get_nodes_in_group("enemy_shots"):
			enemyshot.destroy()
		# move to summary screen
		if SceneManager.OnLastLevel():
			SceneManager.SwitchScene("SummaryFinal");
		else:
			SceneManager.SwitchScene("Summary");

func _on_enemy_defeated():
	defeated_enemies += 1
	
	if get_tree() == null:
		print("Scene tree is not available.")
		return
		
	enemy_kill_counter.text = str(defeated_enemies) + "/" + str(level_goal);
	
	if defeated_enemies >= level_goal:
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.force_safe_remove()
		for shot in get_tree().get_nodes_in_group("shots"):
			shot.force_safe_remove()
		for enemyshot in get_tree().get_nodes_in_group("enemy_shots"):
			enemyshot.force_safe_remove()
		if SceneManager.OnLastLevel():
			SceneManager.SwitchScene("SummaryFinal");
		else:
			SceneManager.SwitchScene("Summary");

func already_won():
	return defeated_enemies >= level_goal
