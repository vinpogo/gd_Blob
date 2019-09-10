extends Sprite
signal aim
signal jump

var isAiming = false
onready var blob = $".."
func _ready():
	visible = false

func _process(delta):
	set_scale(Vector2((get_global_mouse_position() - global_position).length()/100, 1))
	if canAim():
		visible = true
	else:
		visible = false

	if Input.is_action_just_released("jump") && blob.canJump() && canAim():
		jump()
	if Input.is_action_just_pressed("jump") && blob.canJump() && canAim():
		emit_signal("aim")
		
	rotation = ru_rotation()

func ru_rotation():
	return (get_global_mouse_position() - global_position).angle() - blob.rotation
	
func canAim():
	var gravity = blob.gravity_dir
	var projection = get_global_mouse_position()-global_position

	if !blob.onFloor :
		return true
	if blob.onFloor && gravity.dot(projection) < 0:
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