extends Sprite
signal aim
signal jump

var isAiming = false

func _ready():
	visible = false

func _process(delta):
	if Input.is_action_just_released("jump"):
		stopAim()
		if $"..".canJump():
			jump()

	if Input.is_action_pressed("jump") && canAim():
		startAim()
	if isAiming:
		rotation = ru_rotation()

func ru_rotation():
	return (get_global_mouse_position() - global_position).angle() - $"..".rotation
func canAim():
	if (get_global_mouse_position() - global_position).normalized().dot($"..".gravity_dir.normalized()) > 0:
		return false
	return true
func startAim():
	if $"..".canJump():
		visible = true
		isAiming = true
		emit_signal("aim")
func stopAim():
	if isAiming:
		visible = false
		isAiming = false
func jump():
	emit_signal("jump")