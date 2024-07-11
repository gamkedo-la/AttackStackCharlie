extends CharacterBody2D
# based on code from tutorial at https://www.youtube.com/watch?v=AHK5aQ7xvH8

@export var shipSpritePath: NodePath

@onready var shipSprite = get_node(shipSpritePath) as Node2D


const SHIP_SPEED = 250
const SHOT_SPREAD = 25

const LEVEL_TYPE = preload("res://Globals/level_type_enum.gd").LevelType
var LEVEL_TYPE_LIST = LEVEL_TYPE.keys()
const ROF = 0.2

# Can be split too if needed. Potentially inside the dictionary
# If leveling up logic becomes more complex, it could be extracted to an object 
# with specific logic to level up each dimension 
const MAX_LEVELS = 3

var shot_levels_dict = {
	ROF = 0,
	SPLIT = 0,
}

var lastShotTime = 0.0
# var shotLev = 0;
# var shotSplit = 1;
var shotBasic = preload("res://PlayerShots/PlayerShotBasic.tscn");
var shipFacing = Vector2.UP;

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move left"):
		move_vec.x -= 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.LEFT;
			shipSprite.rotation = -PI/2
	if Input.is_action_pressed("move right"):
		move_vec.x += 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.RIGHT;
			shipSprite.rotation = PI/2
	if Input.is_action_pressed("move up"):
		move_vec.y -= 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.UP;
			shipSprite.rotation = 0
	if Input.is_action_pressed("move down"):
		move_vec.y += 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.DOWN;
			shipSprite.rotation = PI
	move_and_collide(move_vec * delta * SHIP_SPEED)

func _process(delta):
	if Input.is_action_pressed("shoot"):
		fire()

func upgradeShot(type):
	shot_levels_dict[type] = min(MAX_LEVELS - 1, shot_levels_dict[type] + 1)
	print(shot_levels_dict)
	

func fire():
	print("get_time ", get_time())
	print("lastShotTime ", lastShotTime)
	print("get_time - lastShotTime ", get_time() - lastShotTime)
	print("ROF * (SHOT_LEVELS-shotLev) ", ROF * (MAX_LEVELS-shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]]))
	if get_time() - lastShotTime < ROF * (MAX_LEVELS-shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]]):
		return
	lastShotTime = get_time()
	for n in shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.SPLIT]] + 1:
		var xOffset = (shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.SPLIT]]-1.0)/2.0
		var shot = shotBasic.instantiate();
		get_tree().root.add_child(shot);
		shot.activateShot(shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]], shipFacing);
		var shotSweepEdgeL = Vector2.LEFT
		var shotSweepEdgeR = Vector2.RIGHT
		if shipFacing == Vector2.LEFT || shipFacing == Vector2.RIGHT:
			shotSweepEdgeL = Vector2.UP
			shotSweepEdgeR = Vector2.DOWN
		shot.global_position = $ShootFrom.global_position + shipFacing*25 + (shotSweepEdgeL*xOffset+shotSweepEdgeR*n)*SHOT_SPREAD

func get_time():
	return Time.get_ticks_msec() / 1000.0
