extends Node

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause")):
		var current_value : bool = get_tree().paused
		get_tree().paused = !current_value
