extends Node2D

onready var blobChar = get_node("BlobCharacter")
onready var tween = get_node("rotation")
signal rotate(angle)
func _on_ready():
	emit_signal("rotate", blobChar.compass.up.angle()-PI/2)
	rotation = blobChar.compass.up.angle()-PI/2

func _on_BlobCharacter_stick():
	position = blobChar.global_position
	blobChar.position = Vector2(0,0)
	emit_signal("rotate", blobChar.compass.down.angle()-PI/2)
	tween.interpolate_property(self, "rotation", null, blobChar.compass.down.angle()-PI/2, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
