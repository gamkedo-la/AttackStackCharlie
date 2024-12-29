class_name CriticalDangerFeedback extends Node

const LastEnemyMessage = "Last Enemy!"
const LowHealthMessage = "Health Low!"
const TimeRunningOutMessage = "Hurry Up!"

@export var message_display_time_secs = 2
@export var time_running_out_threshold_secs = 30
const normal_music_path = "res://Audio/AttackStackCharlie-Audio-rodrigo.ogg"
const panic_music_path = "res://Audio/HurryMode0-vaan.ogg"

# RoundManager is the owner of win conditions
@onready var roundManager = get_tree().current_scene.get_node("EveryLevelReusedStuff")
@onready var feedback_text = $FeedbackText
@onready var timer = $FeedbackTimer
@onready var countdown = get_tree().current_scene.get_node("EveryLevelReusedStuff/Countdown")
@onready var player_node = get_tree().current_scene.get_node("EveryLevelReusedStuff/Player")
@onready var music_player = get_tree().current_scene.get_node("EveryLevelReusedStuff/MusicPlayer")

var low_time_message_displayed: bool = false
var panic_state: bool = false

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
	
	if !is_instance_valid(countdown):
		push_error("CriticalDangerFeedback: Countdown not in scene!")
		
	player_node.player_health_decreased.connect(on_player_health_decreased)

	# Start normal music
	play_music(normal_music_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Tick not the best but works for now
	check_low_time()

func check_low_time():
	# Only display the message once
	if !is_instance_valid(countdown) or low_time_message_displayed:
		return
	if countdown.time_left <= time_running_out_threshold_secs:
		low_time_message_displayed = true
		activate_panic_state(TimeRunningOutMessage)

func on_enemy_defeated():
	# print("CriticalDangerFeedback: Enemy Defeated")
	var enemiesRemaining = roundManager.level_goal - roundManager.defeated_enemies

	# Check if it is the last enemy and if so will show message to player
	if enemiesRemaining == 1:
		show_message(LastEnemyMessage)
		activate_panic_state(LastEnemyMessage)
	elif enemiesRemaining == 0:
		# Hide any messages as victory text will display
		force_hide_message()

func on_player_health_decreased():
	print("CriticalDangerFeedback: Player health decreased")
	# Check if 1 remaining health
	var healthRemaining = PlayerVars.player_health
	
	if healthRemaining <= PlayerVars.player_min_health:
		PlayerVars.player_health = PlayerVars.player_min_health
		healthRemaining = PlayerVars.player_health
		
	if healthRemaining == 1:
		activate_panic_state(LowHealthMessage)

func activate_panic_state(reason: String):
	if not panic_state:
		panic_state = true
		show_message(reason)
		play_music(panic_music_path)

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

func play_music(music_path: String):
	if is_instance_valid(music_player):
		var music_stream = ResourceLoader.load(music_path)
		music_stream.loop = true
		music_player.stream = music_stream
		# music_player.stream = ResourceLoader.load(music_path)
		music_player.play()
