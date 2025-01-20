extends CanvasLayer

@onready var sprite = $CRTEffect

@export var enable_crt: bool = true

var original_material

func _ready():
	original_material = sprite.material
	
	toggle_crt(enable_crt)

func toggle_crt(enable):
	var material = original_material if enable else null
	
	sprite.material = material
	sprite.visible = enable
	
	enable_crt = enable
	
	if !enable:
		print("Disabling CRT effect")
