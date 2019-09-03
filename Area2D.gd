extends Area2D
signal bounce
signal stopBounce
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BounceArea_body_entered(body):
	emit_signal("bounce")
	print(str('Body entered: ', body.get_name()))


func _on_BounceArea_body_exited(body):
	emit_signal("stopBounce")
	pass # Replace with function body.
