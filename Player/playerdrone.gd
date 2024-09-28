extends CharacterBody2D

@export var droneSpritePath: NodePath
@onready var droneSprite = get_node(droneSpritePath) as Node2D

const SPEED = 7.0
const ANGLE_CHANGE = 4
const DISTANCE = 80.0
var current_angle = 0.0
var player_position = Vector2()
var drone_facing = Vector2()

func _ready():
	var player_node = get_tree().current_scene.get_node("EveryLevelReusedStuff/Player")
	player_node.connect("player_moved", Callable(self, "_on_player_moved"))
	player_node.connect("player_turned", Callable(self, "_on_player_turned"))
	player_node.connect("player_fired", Callable(self, "_on_player_fired"))

func _on_player_turned(new_rotation):
	# note: ignoring player's rotation to aim at mouse, so distance from player "focuses" fire
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	droneSprite.rotation = direction.angle();
	drone_facing = Vector2.RIGHT.rotated(rotation)

func _on_player_moved(new_position):
	player_position = new_position

func _on_player_fired(ship):
	for n in ship.shot_levels_dict[ship.LEVEL_TYPE_LIST[ship.LEVEL_TYPE.SPLIT]] + 1:
		var xOffset = (ship.shot_levels_dict[ship.LEVEL_TYPE_LIST[ship.LEVEL_TYPE.SPLIT]]-1.0)/2.0
		var shot = ship.shotBasic.instantiate();
		get_tree().root.add_child(shot);
		shot.activateShot(ship.shot_levels_dict[ship.LEVEL_TYPE_LIST[ship.LEVEL_TYPE.ROF]], 
			ship.BASE_SHOT_LIFE + ship.shot_levels_dict[ship.LEVEL_TYPE_LIST[ship.LEVEL_TYPE.RANGE]] * ship.EXTRA_SHOT_LIFE_INCREMENT,
			ship.shipFacing);
		var shotSweepEdgeL = Vector2.LEFT
		var shotSweepEdgeR = Vector2.RIGHT
		if ship.shipFacing == Vector2.LEFT || ship.shipFacing == Vector2.RIGHT:
			shotSweepEdgeL = Vector2.UP
			shotSweepEdgeR = Vector2.DOWN
		shot.global_position = $ShootFrom.global_position + ship.shipFacing*25 + (shotSweepEdgeL*xOffset+shotSweepEdgeR*n)*ship.SHOT_SPREAD

func _physics_process(delta):
	current_angle += delta * ANGLE_CHANGE
	position.x = player_position.x + DISTANCE * cos(current_angle)
	position.y = player_position.y + DISTANCE * sin(current_angle)
	move_and_slide()
