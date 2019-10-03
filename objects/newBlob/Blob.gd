extends Node2D

onready var blob = get_node("BlobCharacter")


func _ready():
	rotation = -blob.gravity_dir.angle()-PI/2

func _on_BlobCharacter_stick():
	position = blob.global_position
	blob.position = Vector2(0,0)
	rotation = blob.gravity_dir.angle()-PI/2
	pass # Replace with function body.
