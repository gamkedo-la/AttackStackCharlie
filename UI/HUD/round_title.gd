extends Node

@onready var message = get_node("Message")
@onready var tween = create_tween()
var round = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	message.text = "Round %s" % round
	tween.tween_property(self, "modulate", Color.GRAY, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(self.queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
