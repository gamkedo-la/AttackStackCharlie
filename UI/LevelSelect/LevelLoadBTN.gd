extends Button

@export var map_name: String = ""

func _ready():
	pass

func _process(delta):
	pass

func _on_pressed():
	if map_name != "":
		SceneManager.SwitchScene(map_name)
	else:
		print("ERROR: Map name missing for button!")
