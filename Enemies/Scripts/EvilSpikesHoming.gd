extends "res://Enemies/Scripts/Enemy.gd"

enum State { HORIZONTAL_MOVE, PAUSE, VERTICAL_MOVE }
const HOMING_SPEED = 90
var current_state = State.HORIZONTAL_MOVE
var behavior_switch_timer = 0.0
var last_move_was_horizontal = true

func _ready():
	super._ready()
	last_move_was_horizontal = randf_range(0.0,1.0)<0.5
	set_process(true)

func _process(delta):
	behavior_switch_timer -= delta
	
	if(behavior_switch_timer <0):
		if current_state != State.PAUSE:
			behavior_switch_timer = randf_range(0.3, 0.85) # how long to wait
		
		if current_state == State.HORIZONTAL_MOVE:
			last_move_was_horizontal = true
			current_state = State.PAUSE
		elif current_state == State.VERTICAL_MOVE:
			last_move_was_horizontal = false
			current_state = State.PAUSE
		else:
			behavior_switch_timer = randf_range(1.0, 2.5)  # how long to move
			if last_move_was_horizontal:
				current_state = State.VERTICAL_MOVE
			else:
				current_state = State.HORIZONTAL_MOVE
	
	var closeEnoughHorizontal = abs(position.x - targetPos.x) < 10
	var closeEnoughVertical = abs(position.y - targetPos.y) < 10
	
	match current_state:
		State.HORIZONTAL_MOVE:
			moveDir.x = sign(targetPos.x - position.x)
			moveDir.y = 0
			if closeEnoughHorizontal:
				behavior_switch_timer = -0.1
		State.PAUSE:
			moveDir.x = 0
			moveDir.y = 0
		State.VERTICAL_MOVE:
			moveDir.x = 0
			moveDir.y = sign(targetPos.y - position.y)
			if closeEnoughVertical:
				behavior_switch_timer = -0.1
	position += moveDir * HOMING_SPEED * delta
