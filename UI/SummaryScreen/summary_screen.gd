extends Node2D
@onready var shots_fired = $"Shots Fired"
@onready var hits_taken = $"Hits Taken"
@onready var time = $Time
@onready var score = $Score
@onready var powerups_collected = $"Powerups Collected"


# Called when the node enters the scene tree for the first time.
func _ready():
	shots_fired.text = "Shots Fired: " + str(PlayerVars.shots_fired);
	hits_taken.text = "Hits Taken: " + str(PlayerVars.hits_taken);
	time.text = "Total Time: " + str(PlayerVars.time_in_level);
	#score.text = "Final Score: " + str(PlayerVars.score);
	powerups_collected.text = "Powerups Collected: " + str(PlayerVars.powerups_collected);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass