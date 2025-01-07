extends Node
class_name NSceneManager

@export var Scenes : Dictionary = {}

var levels = ["TestLevelA", "TestLevelB", "TestLevelC", "TestLevelD", 
			  "TestLevelE", "TestLevelF", "TestLevelG", "TestLevelH", 
			  "TestLevelI", "TestLevelJ"]
var currentLevelAlias = "TestLevelA"

var m_CurrentSceneAlias : String = ""
var intro_has_already_played : bool = false

# migrating game_manager script stuff related to pause menu into here
signal toggle_game_paused(is_paused : bool)

# migrating game_manager script stuff related to pause menu into here
var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

# Find the initial scene as defined in the project settings
func _ready() -> void:
	var mainScene : StringName = ProjectSettings.get_setting("application/run/main_scene")
	m_CurrentSceneAlias = Scenes.find_key(mainScene)

func AddScene(sceneAlias : String, scenePath : String) -> void:
	Scenes[sceneAlias] = scenePath
	
func RemoveScene(sceneAlias : String) -> void:
	Scenes.erase(sceneAlias)
	
func SwitchScene(sceneAlias : String) -> void:
	if levels.find(sceneAlias) != -1:
		currentLevelAlias = sceneAlias
	get_tree().change_scene_to_file(Scenes[sceneAlias])

func RestartScene() -> void:
	if(get_tree().current_scene.get_node("EveryLevelReusedStuff").already_won()):
		return
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	get_tree().reload_current_scene()
	
func GoToNextLevel() -> void:
	var nextLevelIndex = levels.find(currentLevelAlias) + 1
	# should probably go to a credits screen or something if at the end of the array
	SwitchScene(levels[nextLevelIndex])

func QuitGame() -> void:
	get_tree().quit()
	
func GetSceneCount() -> int:
	return Scenes.size()
	
func GetCurrentSceneAlias() -> String:
	return m_CurrentSceneAlias

# migrating game_manager script stuff related to pause menu into here
func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause")):
		game_paused = !game_paused
		if game_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
