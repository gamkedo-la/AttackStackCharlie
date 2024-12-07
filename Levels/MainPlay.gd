extends Node2D
var RoundTitle = preload("res://UI/HUD/round_title.tscn")
@export var LevelName = "StageName";
var timerCount: int = 100;
@onready var timer = get_tree().current_scene.get_node("EveryLevelReusedStuff/Timer");
@onready var countdown = get_tree().current_scene.get_node("EveryLevelReusedStuff/Countdown");
@onready var health = get_tree().current_scene.get_node("EveryLevelReusedStuff/Health");

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVars.player_health = PlayerVars.player_max_health
	updateHealthDisplay();
	var roundTitle = RoundTitle.instantiate()
	add_child(roundTitle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer.text = "TIME: " + str(snapped(countdown.time_left, 1));
	updateHealthDisplay();
	
	if (countdown.time_left <= 0):
		SceneManager.RestartScene();
		
	pass

func updateHealthDisplay():
	# Health was null initially when selecting a level from "Level Select" on main menu
	# Probably only needed temporarily as see health is defined on main play through
	if !is_instance_valid(health): return
	
	health.text = "HEALTH: " + str(PlayerVars.player_health) + "/" + str(PlayerVars.player_max_health)
