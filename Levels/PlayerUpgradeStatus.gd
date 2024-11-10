extends RichTextLabel

func item_unlock_debug_text_update():
	clear()
	for key in PlayerVars.powerup_paths:
		var textColor
		if check_perhit_stat(key["stat"]) >= key["minimum"]:
			textColor = "green"
		else:
			textColor = "white"
		append_text("[color="+textColor+"]" + key["word"] + ": " + key["stat"] + " " + str(round(check_perhit_stat(key["stat"]))) + "/" + 
					str(key["minimum"]) + "[/color]\n")

func check_perhit_stat(stat_name: String):
	if stat_name in PlayerVars.perhit_stats:
		return PlayerVars.perhit_stats[stat_name]
	else:
		print("player_vars.gd Stat not found:", stat_name)
		return "MISSING_STAT_"+stat_name

func _ready():
	item_unlock_debug_text_update()

var infreq_update_timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	infreq_update_timer+=delta
	if infreq_update_timer>0.2:
		infreq_update_timer=0.0
		item_unlock_debug_text_update()
