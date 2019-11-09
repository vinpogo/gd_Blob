extends Camera2D

var target
onready var tween = get_node("Tween")
func _physics_process(delta):
		if target:
				position = target.position

func connect_signals():
	target.connect("rotate", self, "_on_Character_rotate")


func _on_Character_rotate(vec) -> void:
	var angle = vec.angle()
	var rot = rotation - PI / 2
	tween.interpolate_property(self, "rotation", null, rotation + global.short_angle_dist(rot, angle), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()