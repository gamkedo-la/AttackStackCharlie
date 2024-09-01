extends CharacterBody2D
# based on code from tutorial at https://www.youtube.com/watch?v=AHK5aQ7xvH8

@export var shipSpritePath: NodePath
@onready var shipSprite = get_node(shipSpritePath) as Node2D
@onready var player_upgrade_status = $"../PlayerUpgradeStatus"
signal player_moved(new_position)
signal player_turned(new_facing)
signal player_fired(ship)

const SHIP_SPEED = 250
const SHOT_SPREAD = 25

const LEVEL_TYPE = preload("res://Globals/level_type_enum.gd").LevelType
var LEVEL_TYPE_LIST = LEVEL_TYPE.keys()
const ROF = 0.5
const EXTRA_ROF_TIME_DECREASE = 0.1
const BASE_SHOT_LIFE = 0.5
const EXTRA_SHOT_LIFE_INCREMENT = 0.3

# Can be split too if needed. Potentially inside the dictionary
# If leveling up logic becomes more complex, it could be extracted to an object 
# with specific logic to level up each dimension 
const MAX_LEVELS = 3
var lastShotTime = 0.0
var shotBasic = preload("res://PlayerShots/PlayerShotBasic.tscn");
const shotSound = preload("res://Raw Source Files/AUDIO/SFX/Sx_PlayerWeapon_Standard_Laser_A_01.wav");
var shipFacing = Vector2.UP;
var shot_levels_dict = {
	ROF = 0,
	SPLIT = 0, # This means that we need to add a + 1 later. The price of the generic implementation of MAX_LEVELS. We may need to customize them in the end.
	RANGE = 0,
}

# Damage immunity after hit
var time_modulated: float = 0.3
var time_modulated_elapsed: float = 0
var is_damaged: bool = false

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move left"):
		move_vec.x -= 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.LEFT;
			shipSprite.rotation = PI
	if Input.is_action_pressed("move right"):
		move_vec.x += 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.RIGHT;
			shipSprite.rotation = 0
	if Input.is_action_pressed("move up"):
		move_vec.y -= 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.UP;
			shipSprite.rotation = -PI/2
	if Input.is_action_pressed("move down"):
		move_vec.y += 1
		if Input.is_action_pressed("shoot") == false:
			shipFacing = Vector2.DOWN;
			shipSprite.rotation = PI/2
	move_and_collide(move_vec * delta * SHIP_SPEED)
	
	if is_damaged and time_modulated_elapsed > time_modulated:
		is_damaged = false
		time_modulated_elapsed = 0
	elif is_damaged:
		time_modulated_elapsed += delta
	emit_signal("player_moved", global_position)
	emit_signal("player_turned", shipFacing)

func _process(delta):
	if Input.is_action_pressed("shoot"):
		fire()

func upgradeShot(type):
	shot_levels_dict[type] = min(MAX_LEVELS - 1, shot_levels_dict[type] + 1)
	player_upgrade_status.text = "";
	for key in shot_levels_dict:
		player_upgrade_status.text += (key + ": " + str(shot_levels_dict[key]) + "\n");
	# print(shot_levels_dict)
	

func fire():
	# print("get_time ", get_time())
	# print("lastShotTime ", lastShotTime)
	# print("get_time - lastShotTime ", get_time() - lastShotTime)
	# print("ROF * (SHOT_LEVELS-shotLev) ", ROF * (MAX_LEVELS-shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]]))
	if get_time() - lastShotTime < ROF -EXTRA_ROF_TIME_DECREASE*shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]]:
		return
	$SX_PlayShootBasic.play()	
	lastShotTime = get_time()
	for n in shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.SPLIT]] + 1:
		var xOffset = (shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.SPLIT]]-1.0)/2.0
		var shot = shotBasic.instantiate();
		get_tree().root.add_child(shot);
		shot.activateShot(shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]], 
			BASE_SHOT_LIFE + shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.RANGE]] * EXTRA_SHOT_LIFE_INCREMENT,
			shipFacing);
		var shotSweepEdgeL = Vector2.LEFT
		var shotSweepEdgeR = Vector2.RIGHT
		if shipFacing == Vector2.LEFT || shipFacing == Vector2.RIGHT:
			shotSweepEdgeL = Vector2.UP
			shotSweepEdgeR = Vector2.DOWN
		shot.global_position = $ShootFrom.global_position + shipFacing*25 + (shotSweepEdgeL*xOffset+shotSweepEdgeR*n)*SHOT_SPREAD
	emit_signal("player_fired", self)

func get_time():
	return Time.get_ticks_msec() / 1000.0

func _damage_player() -> void:
	Events.emit_signal("player_hit")
	if is_damaged == false:
		is_damaged = true
		if(PlayerVars.player_shield > 0):
			PlayerVars.player_shield -= 1
			pass
		PlayerVars.player_health -= 1
		# print("Player damaged, current player health: ", PlayerVars.player_health)
		if PlayerVars.player_health <= 0:
			# Will need to be substituted for a signal or a call to whatever we actually want to do on death
			SceneManager.RestartScene()
	else:
		pass

func _on_enemy_detector_area_entered(area):
	# print("Enemy Detected, current player health: ", PlayerVars.player_health)
	_damage_player()
	
	area.queue_free()
