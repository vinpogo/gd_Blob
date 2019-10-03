extends Node2D

onready var blob = get_node("BlobCharacter")
onready var tween = get_node("rotation")

func _ready():
	rotation = -blob.gravity_dir.angle()-PI/2

func _on_BlobCharacter_stick():
	position = blob.global_position
	blob.position = Vector2(0,0)
	tween.interpolate_property(self, "rotation", null, blob.gravity_dir.angle()-PI/2, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
#	rotation = blob.gravity_dir.angle()-PI/2
	pass # Replace with function body.
