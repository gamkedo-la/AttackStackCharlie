extends Node
@export var skipIntroForFasterTesting: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if skipIntroForFasterTesting:
		print("TITLE/SPLASH/MENU BYPASSED for instant play - skipIntroForFasterTesting in inspector top of main_menu.tscn")
		SceneManager.SwitchScene("MainPlay")
