extends Node2D

onready var blobChar = get_node("Character")
onready var tween = get_node("rotation")
onready var compass = blobChar.compass
signal rotate(vec)
signal jump


func _on_ready():
	emit_signal("rotate", blobChar.compass.up)
	rotation = blobChar.compass.up.angle()-PI/2

func _on_BlobCharacter_stick(col:Vector2):
	position = blobChar.global_position
	blobChar.position = Vector2(0,0)

	var angle = col.angle()
	var rot = rotation - PI / 2
	tween.interpolate_property(self, "rotation", null, rotation + short_angle_dist(rot, angle), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	emit_signal("rotate", col)


func _on_GameZone_body_shape_exited(body_id: int, body: PhysicsBody2D, body_shape: int, area_shape: int) -> void:
	blobChar.die()

func short_angle_dist(from, to):
		var max_angle = PI * 2
		var difference = fmod(to - from, max_angle)
		return fmod(2 * difference, max_angle) - difference

func _on_BlobCharacter_jump() -> void:
	emit_signal("jump")
