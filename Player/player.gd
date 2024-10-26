extends CharacterBody2D
# based on code from tutorial at https://www.youtube.com/watch?v=AHK5aQ7xvH8

@onready var player_upgrade_status = get_tree().current_scene.get_node("EveryLevelReusedStuff/PlayerUpgradeStatus")
signal player_moved(new_position)
signal player_turned(new_facing)
signal player_fired(ship)
signal player_upgraded(type)

const SHIP_SPEED = 150 # multiplier on a value otherwise much smaller, easier tuning
const SHIP_ACCEL = 0.2
const SHIP_VEL_DECAY = 0.925
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
const MAX_DRONES = 7

var lastShotTime = 0.0
var shotBasic = preload("res://PlayerShots/PlayerShotBasic.tscn");
const shotSound = preload("res://Raw Source Files/AUDIO/SFX/Sx_PlayerWeapon_Standard_Laser_A_01.wav");
var shipFacing = Vector2.UP;
var shot_levels_dict = {
	ROF = 0,
	SPLIT = 0, # This means that we need to add a + 1 later. The price of the generic implementation of MAX_LEVELS. We may need to customize them in the end.
	RANGE = 0,
}
var droneToSpawn = preload("res://Player/playerdrone.tscn");

# Damage immunity after hit
var time_modulated: float = 0.3
var time_modulated_elapsed: float = 0
var is_damaged: bool = false
var is_invincible: bool = false
var invincibility_time: float = 0;
var move_vec = Vector2()
var playerDrones = Node.new();

func _ready():
	playerDrones.name = "PlayerDrones"
	add_child(playerDrones)

func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	shipFacing = (mouse_position - global_position).normalized()
	rotation = shipFacing.angle()
	move_vec *= SHIP_VEL_DECAY
	if Input.is_action_pressed("move left"):
		move_vec.x -= SHIP_ACCEL
	if Input.is_action_pressed("move right"):
		move_vec.x += SHIP_ACCEL
	if Input.is_action_pressed("move up"):
		move_vec.y -= SHIP_ACCEL
	if Input.is_action_pressed("move down"):
		move_vec.y += SHIP_ACCEL
	var vecMovedThisFrame = move_vec * delta * SHIP_SPEED
	move_and_collide(vecMovedThisFrame)
	
	PlayerVars.increase_stat("player_distance_moved", vecMovedThisFrame.length(), false)
	
	if vecMovedThisFrame.length() > 0:
		PlayerVars.reset_stat("time_since_player_moved", false)
		
	if is_damaged and time_modulated_elapsed > time_modulated:
		is_damaged = false
		time_modulated_elapsed = 0
	elif is_damaged:
		time_modulated_elapsed += delta
		
	if is_invincible:
		invincibility_time -= delta;
	
	if (invincibility_time <= 0):
		invincibility_time = 0;
		is_invincible = false;
		
	emit_signal("player_moved", global_position)
	emit_signal("player_turned", rotation)

func _process(delta):
	PlayerVars.increase_stat("time_in_level", delta, false)
	PlayerVars.increase_stat("time_since_last_shot_fired", delta, false)
	PlayerVars.increase_stat("time_since_last_hit", delta, false)
	PlayerVars.increase_stat("time_since_player_moved", delta, false)
	if Input.is_action_pressed("shoot"):
		fire()

func upgradeShot(type):
	shot_levels_dict[type] = min(MAX_LEVELS - 1, shot_levels_dict[type] + 1)
	player_upgrade_status.text = "";
	for key in shot_levels_dict:
		player_upgrade_status.text += (key + ": " + str(shot_levels_dict[key]) + "\n");
	player_upgraded.emit(type)

func upgradeInvincibility(invincible_time):
	is_invincible = true;
	invincibility_time = invincible_time;

func upgradeDrone():
	var drone_count = playerDrones.get_child_count()
	if drone_count >= MAX_DRONES:
		print("drones maxed out, give player feedback (or avoid powerup spawn)")
		return
	call_deferred("addDroneAndUpdateSpacing")

func addDroneAndUpdateSpacing():
	var newDrone = droneToSpawn.instantiate();
	playerDrones.add_child(newDrone)
	var drone_count = playerDrones.get_child_count()
	for i in range(drone_count):
		var drone = playerDrones.get_child(i)
		var angle = i * 2 * PI / drone_count
		drone.setGroupAngleOffset(angle)

func fire():
	# print("get_time ", get_time())
	# print("lastShotTime ", lastShotTime)
	# print("get_time - lastShotTime ", get_time() - lastShotTime)
	# print("ROF * (SHOT_LEVELS-shotLev) ", ROF * (MAX_LEVELS-shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]]))
	if get_time() - lastShotTime < ROF -EXTRA_ROF_TIME_DECREASE*shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]]:
		return
	$SX_PlayShootBasic.play()	
	lastShotTime = get_time()
	PlayerVars.increase_stat("shots_fired",1,false)
	PlayerVars.reset_stat("time_since_last_shot_fired", false)
	for n in shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.SPLIT]] + 1:
		var xOffset = (shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.SPLIT]]-1.0)/2.0
		var shot = shotBasic.instantiate();
		get_tree().root.add_child(shot);
		shot.activateShot(shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.ROF]], 
			BASE_SHOT_LIFE + shot_levels_dict[LEVEL_TYPE_LIST[LEVEL_TYPE.RANGE]] * EXTRA_SHOT_LIFE_INCREMENT,
			shipFacing);
		var shotSweepEdgeL = Vector2.LEFT.rotated(rotation+PI/2)
		var shotSweepEdgeR = Vector2.RIGHT.rotated(rotation+PI/2)
		shot.global_position = $ShootFrom.global_position + shipFacing*25 + (shotSweepEdgeL*xOffset+shotSweepEdgeR*n)*SHOT_SPREAD
	emit_signal("player_fired", self)

func get_time():
	return Time.get_ticks_msec() / 1000.0

func _damage_player() -> void:
	if (is_invincible):
		return;
		
	Events.emit_signal("player_hit")
	if is_damaged == false:
		is_damaged = true
		if(PlayerVars.player_shield > 0):
			PlayerVars.player_shield -= 1
			pass
		PlayerVars.player_health -= 1
		PlayerVars.increase_stat("hits_taken", 1, false)
		PlayerVars.reset_stat("time_since_last_hit", false)
		# print("Player damaged, current player health: ", PlayerVars.player_health)
		if PlayerVars.player_health <= 0:
			# Will need to be substituted for a signal or a call to whatever we actually want to do on death
			PlayerVars.reset()
			SceneManager.RestartScene()
		else:
			PlayerVars.reset_respawn_stats()
	else:
		pass

func _on_enemy_detector_area_entered(area):
	# print("Enemy Detected, current player health: ", PlayerVars.player_health)
	_damage_player()
	
	area.queue_free()
