class_name CriticalDanagerFeedback extends Node

# TODO: Add "taking too long" feedback
# TODO: Add low player health feedback

# RoundManager is the owner of win conditions
@onready var roundManager = get_tree().current_scene.get_node("EveryLevelReusedStuff")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_enemy_defeated():
	# print("CriticalDanagerFeedback: Enemy Defeated")

	# Check if it is the last enemy and if so will show message to player
	# TODO: Add message like "A: Wading in" on screen
	if roundManager.level_goal - roundManager.defeated_enemies == 1:
		print("LAST ENEMY!")
