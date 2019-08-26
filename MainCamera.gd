extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lastRotation = 0
var newRotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Blob_switchGravity(dir):
	newRotation = dir.angle()
	
	if newRotation != lastRotation: 
		rotate(newRotation - lastRotation)
		lastRotation = newRotation
