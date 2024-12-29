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
	health.max_value = PlayerVars.player_max_health;
	health.value = PlayerVars.player_health;
	health.get("theme_override_styles/fill").bg_color = Color.GREEN;
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
	
	var current_health = max(PlayerVars.player_min_health, PlayerVars.player_health)
	health.value = current_health;
	
	# healthbar is yellow at 70% health
	if health.value <= 0.7 * health.max_value:
		health.get("theme_override_styles/fill").bg_color = Color.YELLOW;
		
	# healthbar is red at 35% health	
	if health.value <= 0.35 * health.max_value:
		health.get("theme_override_styles/fill").bg_color = Color.RED;
	
		
