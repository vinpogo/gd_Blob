extends Node2D

onready var blobChar = get_node("BlobCharacter")
onready var tween = get_node("rotation")
onready var compass = blobChar.compass
signal rotate(angle)
func _on_ready():
	emit_signal("rotate", blobChar.compass.up.angle()-PI/2)
	rotation = blobChar.compass.up.angle()-PI/2

func _on_BlobCharacter_stick():
	position = blobChar.global_position
	blobChar.position = Vector2(0,0)
	
	var angle = blobChar.compass.down.angle()-PI/2
	var a = angle if abs(angle - rotation) < PI else angle + 2*PI
	emit_signal("rotate", a)
	tween.interpolate_property(self, "rotation", null, a, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()


func _on_GameZone_body_shape_exited(body_id: int, body: PhysicsBody2D, body_shape: int, area_shape: int) -> void:
	blobChar.die()
