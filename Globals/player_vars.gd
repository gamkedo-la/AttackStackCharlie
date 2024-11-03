extends Node

@onready var player_upgrade_status = get_tree().current_scene.get_node("EveryLevelReusedStuff/PlayerUpgradeStatus")

var player_max_health: int = 3
var player_health: int = 3
var player_max_shield: int = 6
var player_shield: int = 0;

var stats = {
	# stats for summary screen
	"shots_fired": 0,
	"time_in_level": 0,
	"hits_taken": 0,
	"powerups_collected": 0,
	# stats not necessary for summary, but powerups etc
	"chain_reaction_depth":0,
	"player_distance_moved": 0.0,
	"time_since_last_hit": 0,
	"time_since_last_shot_fired": 0,
	"time_since_player_moved": 0,
	"most_drones_gained": 0, 
}

var powerup_paths = [ # checks stat since last player damage, "hits_taken" won't make sense
	{ "path": "res://Powerups/UpgradeShot_Range.tscn", "word":"Range", "stat": "time_since_player_moved", "minimum": 4 },
	{ "path": "res://Powerups/UpgradeShot_ROF.tscn", "word":"ROF", "stat": "shots_fired", "minimum": 20 },
	{ "path": "res://Powerups/UpgradeShot_Split.tscn", "word":"Split", "stat": "time_in_level", "minimum": 0 }, #per hit, so time since last hit
	{ "path": "res://Powerups/Upgrade_AddDrone.tscn", "word":"Drone", "stat": "time_since_last_shot_fired", "minimum": 2 }
]

# cloning values to track per round (summary screen) separate from powerups (per hit)
var perhit_stats = stats.duplicate() 

func reset():
	reset_respawn_stats();
	for key in stats.keys():
		stats[key] = 0
		
func reset_respawn_stats():
	for key in perhit_stats.keys():
		perhit_stats[key] = 0
	item_unlock_debug_text_update()
		
func reset_stat(stat_name: String, debug: bool = false):
	if stat_name in perhit_stats:
		if debug:
			print("BEFORE RESET")
			print(stat_name + ": " + str(perhit_stats[stat_name]) );
		
		perhit_stats[stat_name] = 0
		
		if debug:
			print("AFTER RESET")
			print(stat_name + ": " + str(perhit_stats[stat_name]) );
	else:
		print("player_vars.gd Stat not found:", stat_name)
	item_unlock_debug_text_update()

func check_round_stat(stat_name: String):
	if stat_name in stats:
		return stats[stat_name]
	else:
		print("player_vars.gd Stat not found:", stat_name)
		return "MISSING_STAT_"+stat_name

func check_perhit_stat(stat_name: String):
	if stat_name in perhit_stats:
		return perhit_stats[stat_name]
	else:
		print("player_vars.gd Stat not found:", stat_name)
		return "MISSING_STAT_"+stat_name

func item_unlock_debug_text_update():
	if not player_upgrade_status:
		player_upgrade_status = get_tree().current_scene.get_node("EveryLevelReusedStuff/PlayerUpgradeStatus")

	player_upgrade_status.text = ""
	for key in powerup_paths:
		player_upgrade_status.text += (key["word"] + ": " + key["stat"] + " " + str(round(check_perhit_stat(key["stat"]))) + "/" + 
					str(key["minimum"]) + "\n")

func increase_stat_if_increased(stat_name: String, amount, debug: bool = false):
	if stat_name in stats:
		var delta = amount-stats[stat_name]
		var deltaSinceHit = amount-perhit_stats[stat_name]
		if delta>0:
			stats[stat_name] = amount
		if deltaSinceHit>0:
			perhit_stats[stat_name] = amount
		# using for debug print, setting value separately above for per hit increase
		if delta>0 || deltaSinceHit>0:
			increase_stat(stat_name,0,debug)

func increase_stat(stat_name: String, amount, debug: bool = false):
	if stat_name in stats:
		stats[stat_name] += amount
		perhit_stats[stat_name] += amount
		item_unlock_debug_text_update()
		if debug:
			var value = stats[stat_name]
			match typeof(value):
				TYPE_FLOAT:
					print("player_vars.gd %s now %.3f per life %.3f" % [stat_name, value, perhit_stats[stat_name]])
				TYPE_INT:
					print("player_vars.gd %s now %d per life %d" % [stat_name, value, perhit_stats[stat_name]])
	else:
		print("player_vars.gd Stat not found:", stat_name)

func _ready():
	reset()

func _process(delta):
	pass
