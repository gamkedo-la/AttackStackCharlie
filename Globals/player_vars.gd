extends Node

var player_max_health: int = 3
var player_health: int = 3
var player_max_shield: int = 6
var player_shield: int = 0;

# stats for summary screen
var shots_fired: int = 10;
var time_in_level: int = 0;
var hits_taken: int = 0;
var powerups_collected: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
