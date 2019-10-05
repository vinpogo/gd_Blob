extends Light2D

onready var tween = get_node("Tween")
onready var blob = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_aim_aim() -> void:
	tween.interpolate_property(self, "energy", null, 3, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self, "texture_scale", null, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.interpolate_property(blob, "jumpFactor", 1, blob.JUMP_FACTOR, 1, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()

func _on_aim_jump() -> void:
	tween.stop_all()
	energy = 0.0
	texture_scale = 1

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	tween.stop_all()
	energy = 0.0
	texture_scale = 1
	blob.jumpFactor = 1


func _on_aim_stopAim() -> void:
	tween.stop_all()
	energy = 0.0
	texture_scale = 1
