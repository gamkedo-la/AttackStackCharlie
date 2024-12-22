extends RichTextLabel

var powerup_ui_elements = []

func item_unlock_debug_text_update():
	clear()
	for i in range(PlayerVars.powerup_paths.size()):
		var key = PlayerVars.powerup_paths[i]
		var ui_element = powerup_ui_elements[i]

		# var text_color = "green" if check_perhit_stat(key["stat"]) >= key["minimum"] else "white"
		ui_element["label"].text = key["stat"] + " " + \
		                            str(round(check_perhit_stat(key["stat"]))) + "/" + str(key["minimum"])

	# for key in PlayerVars.powerup_paths:
	# 	var textColor
	# 	if check_perhit_stat(key["stat"]) >= key["minimum"]:
	# 		textColor = "green"
	# 	else:
	# 		textColor = "white"
	# 	append_text("[color="+textColor+"]" + key["word"] + ": " + key["stat"] + " " + str(round(check_perhit_stat(key["stat"]))) + "/" + 
	# 				str(key["minimum"]) + "[/color]\n")


func check_perhit_stat(stat_name: String):
	if stat_name in PlayerVars.perhit_stats:
		return PlayerVars.perhit_stats[stat_name]
	else:
		print("player_vars.gd Stat not found:", stat_name)
		return "MISSING_STAT_"+stat_name

func _ready():
	var i = 0
	for key in PlayerVars.powerup_paths:
		var control = Control.new()
		control.set_position(Vector2(25, 35 + i * 50))  # Horizontal fixed at 50, vertical based on index
		i += 1
		add_child(control)

		var sprite = Sprite2D.new()
		var texture = load(key["image"])
		if texture:
			sprite.texture = texture
		control.add_child(sprite)

		var label = Label.new()
		label.set_position(Vector2(25,-10))
		control.add_child(label)

		powerup_ui_elements.append({ "control": control, "sprite": sprite, "label": label })

	item_unlock_debug_text_update()

var infreq_update_timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	infreq_update_timer+=delta
	if infreq_update_timer>0.2:
		infreq_update_timer=0.0
		item_unlock_debug_text_update()
