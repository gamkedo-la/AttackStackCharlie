extends Node2D
var RoundTitle = preload("res://UI/HUD/round_title.tscn")
@export var LevelName = "StageName";
var timerCount: int = 100;
@onready var timer = get_tree().current_scene.get_node("EveryLevelReusedStuff/Timer");
@onready var countdown = get_tree().current_scene.get_node("EveryLevelReusedStuff/Countdown");

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVars.player_health = PlayerVars.player_max_health
	var roundTitle = RoundTitle.instantiate()
	add_child(roundTitle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer.text = "TIME: " + str(snapped(countdown.time_left, 1));
	
	if (countdown.time_left <= 0):
		SceneManager.RestartScene();
		
	pass
