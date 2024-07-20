extends Node
class_name NSceneManager

@export var Scenes : Dictionary = {}

var m_CurrentSceneAlias : String = ""

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
	get_tree().reload_current_scene()
	
func QuitGame() -> void:
	get_tree().quit()
	
func GetSceneCount() -> int:
	return Scenes.size()
	
func GetCurrentSceneAlias() -> String:
	return m_CurrentSceneAlias
