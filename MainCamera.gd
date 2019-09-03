extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	self.position = $"../Blob".ru_position()
	pass


func _on_Blob_switchGravity(angle):
	rotate(angle)
	pass # Replace with function body.
