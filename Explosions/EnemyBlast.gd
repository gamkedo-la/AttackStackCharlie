extends Area2D

@onready var particles = $CPUParticles2D

var max_scale = 7
var growth_rate = 0.1
var active = true
var blastDepth = 1
var hit_scale = 0.1

func _ready():
	particles.restart()
	self.connect("area_entered", Callable(self, "_on_Area2D_area_entered"))

func _process(delta):
	if hit_scale < max_scale and active:
		hit_scale += growth_rate # *delta
		update_collision_shape()
	else:
		queue_free()

func update_collision_shape():
	if $CollisionShape2D.shape is CircleShape2D:
		$CollisionShape2D.shape.radius = 10.0 * hit_scale

func _on_Area2D_area_entered(area):
	# print("Area entered: ", area.name) 
	$AudioStreamPlayer.play()
	var areaParent = area.get_parent()
	if areaParent.is_in_group("enemies") and active:
		# print("Destroying enemy: ", areaParent.name)
		if areaParent.has_method("destroy"):
			areaParent.destroy(blastDepth+1)
			# print("blast called destroy - did it register signal?")
		else:
			print("No destroy method found")

func deactivate():
	active = false
