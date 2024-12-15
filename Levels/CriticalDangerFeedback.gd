class_name CriticalDanagerFeedback extends Node

const LastEnemyMessage = "Last Enemy!"
const LowHealthMessage = "Health Low!"
const TimeRunningOutMessge = "Hurry Up!"

# TODO: Add "taking too long" feedback
# TODO: Add low player health feedback

# RoundManager is the owner of win conditions
@onready var roundManager = get_tree().current_scene.get_node("EveryLevelReusedStuff")
@onready var feedback_text = $FeedbackText
@onready var timer = $FeedbackTimer

@export var message_display_time_secs = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_instance_valid(feedback_text):
		feedback_text.visible = false
	else:
		push_error("CriticalDangerFeedback: feedback_text not in scene!")
	
	if is_instance_valid(timer):
		timer.wait_time = message_display_time_secs
		timer.connect("timeout", Callable(self, "on_timer_expired"))
	else:
		push_error("CriticalDangerFeedback: timer not in scene!")
		
	Events.player_hit.connect(on_player_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_enemy_defeated():
	# print("CriticalDanagerFeedback: Enemy Defeated")
	var enemiesRemaining = roundManager.level_goal - roundManager.defeated_enemies

	# Check if it is the last enemy and if so will show message to player
	if enemiesRemaining == 1:
		show_message(LastEnemyMessage)
	elif enemiesRemaining == 0:
		# Hide any messages as victory text will display
		force_hide_message()
		
func on_player_hit():
	print("CriticalDangerFeedback: Player hit")
	# Check if 1 remaining health
	# TODO: Note that this event seems to fire before the health is decremented so need to subtract 1
	var healthRemaining = PlayerVars.player_health - 1
	if healthRemaining == 1:
		show_message(LowHealthMessage)
	
func show_message(text):
	print("CriticalDangerFeedback: " + text)
	# set the text of the feedback text
	if feedback_text == null:
		return
	
	feedback_text.text = text
	feedback_text.visible = true
	if timer:
		timer.start()
		
	# TODO: Fade out and animate the message up the screen
	# or some other text animation like changing size or wiggling
	
func force_hide_message():
	hide_message()
	if timer:
		timer.stop()
		
func on_timer_expired():
	print("CriticalDangerFeedback: Timer expired")
	hide_message()

func hide_message():
	if feedback_text:
		feedback_text.visible = false
