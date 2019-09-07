extends Sprite
signal aim
signal jump

var isAiming = false

func _ready():
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		startAim()
	elif Input.is_action_just_released("jump"):
		stopAim()
	if isAiming:
		rotation = (get_global_mouse_position() - global_position).angle() - $"..".rotation

func startAim():
	if $"..".canJump():
		visible = true
		isAiming = true
		emit_signal("aim")
func stopAim():
	if isAiming:
		visible = false
		isAiming = false
		emit_signal("jump")