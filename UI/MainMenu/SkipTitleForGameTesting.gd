extends Node
@export var skipIntroForFasterTesting: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if skipIntroForFasterTesting:
		print("SPLASH/MENU BYPASSED to test - skipIntroForFasterTesting see top of UI/MainMenu/main_menu.tscn")
		SceneManager.SwitchScene("TestLevelA")

func _on_intro_sequence_animation_finished(anim_name):
	# $BoxContainer/Control/AnimatedLogo.play()
	pass
