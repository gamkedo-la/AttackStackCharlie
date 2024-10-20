extends Node

var player_max_health: int = 3
var player_health: int = 3
var player_max_shield: int = 6
var player_shield: int = 0;

# stats for summary screen
var shots_fired: int;
var time_in_level: int
var hits_taken: int
var powerups_collected: int

# stats not necessary for summary, but powerups etc
var player_distance_moved: float

func reset():
	shots_fired = 0
	time_in_level = 0
	hits_taken = 0
	powerups_collected = 0
	player_distance_moved = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
