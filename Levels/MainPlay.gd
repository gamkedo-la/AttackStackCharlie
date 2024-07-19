extends Node2D
var RoundTitle = preload("res://UI/HUD/round_title.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVars.player_health = PlayerVars.player_max_health
	var roundTile = RoundTitle.instantiate()
	add_child(roundTile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
