extends Control

@export var scene_manager : NSceneManager

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	scene_manager.connect("toggle_game_paused", _on_scene_manager_toggle_game_paused)

func _on_scene_manager_toggle_game_paused(is_paused : bool):
	if(is_paused):
		print("Show called")
		show()
	else:
		print("Hide called")
		hide()
		
func _on_resume_btn_pressed():
	print("resume button pressed")
	scene_manager.game_paused = false

func _on_main_menu_btn_pressed():
	SceneManager.SwitchScene("MainMenu")

func _on_exit_btn_pressed():
	scene_manager.QuitGame()

