extends Node
class_name NSceneManager

@export var Scenes : Dictionary = {}

var m_CurrentSceneAlias : String = ""

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
	get_tree().change_scene_to_file(Scenes[sceneAlias])

func RestartScene() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	get_tree().reload_current_scene()
	
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
