extends Sprite2D

@export var enable_crt: bool = true;

func _ready():
	if !enable_crt:
		print("Disabling CRT effect");
		material = null
		visible = false
