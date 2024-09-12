extends Control

const LEVEL_TYPE = preload("res://Globals/level_type_enum.gd").LevelType

@onready var spread_stack = get_node("SpreadStack")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_upgrade_received(type):
	if (LEVEL_TYPE[type] == LEVEL_TYPE.SPLIT):
		spread_stack.frame += 1
