extends KinematicBody2D

export var gravity = Vector2(0,1)

var target = Vector2()
var velocity = Vector2()

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		target = get_global_mouse_position()

func _process(delta):
	velocity = (target - position - gravity).normalized() * 50
	rotation = velocity.angle()
	velocity = move_and_slide(velocity, gravity)
