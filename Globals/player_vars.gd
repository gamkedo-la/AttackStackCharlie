extends Node

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
    "player_distance_moved": 0.0
}

# cloning values to track per round (summary screen) separate from powerups (per hit)
var perhit_stats = stats.duplicate() 

func reset():
	reset_respawn_stats();
	for key in stats.keys():
		stats[key] = 0
		
func reset_respawn_stats():
	for key in perhit_stats.keys():
		perhit_stats[key] = 0

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
