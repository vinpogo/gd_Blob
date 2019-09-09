extends Sprite
signal aim
signal jump

var isAiming = false
onready var blob = $".."
func _ready():
	visible = false

func _process(delta):
	set_scale(Vector2((get_global_mouse_position() - global_position).length()/100, 1))
	if !canAim():
		stopAim()
	else:
		startAim()

	if Input.is_action_just_released("jump") && blob.canJump() && isAiming:
		jump()
	if Input.is_action_just_pressed("jump") && blob.canJump():
		emit_signal("aim")

	if isAiming:
		rotation = ru_rotation()

func ru_rotation():
	return (get_global_mouse_position() - global_position).angle() - blob.rotation
func canAim():
	var gravity = blob.gravity_dir
	var projection = (get_global_mouse_position()-global_position).project(gravity)


	print( projection.dot(gravity))
	if !blob.onFloor :
		return true
	if blob.onFloor && projection.dot(gravity) < 0:
		return true
	return false
func startAim():
		visible = true
		isAiming = true
func stopAim():
		visible = false
		isAiming = false
func jump():
	emit_signal("jump")

func crossProduct(vec1, vec2):

	var a = vec1.normalized()
	var b = vec2.normalized()
	return a.x * b.y - a.y * b.x