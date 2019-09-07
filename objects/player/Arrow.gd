extends Sprite
signal aim
signal jump

var isAiming = false

func _ready():
	visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		startAim()
	elif Input.is_action_just_released("jump"):
		stopAim()
	if isAiming:
		rotation = (get_global_mouse_position() - global_position).angle() - $"..".rotation

func startAim():
	visible = true
	isAiming = true
	emit_signal("aim")
func stopAim():
	visible = false
	isAiming = false
	emit_signal("jump")