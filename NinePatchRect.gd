extends NinePatchRect

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Blob_jump() -> void:
	rect_size.x -= 124
	print("resize", margin_right, rect_size)
	pass # Replace with function body.
