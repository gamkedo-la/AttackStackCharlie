extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_hit.connect(on_player_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_player_hit():
	$AnimationPlayer.play("player_hit")
	print("PLAYER WAS HIT!!")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "player_hit":
		$AnimationPlayer.play("RESET")
