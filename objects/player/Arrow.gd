extends Sprite
signal aim
signal jump

signal predict

var isAiming = false
onready var blob = get_parent()
func _ready():
	visible = false

func _input(event):
	if event is InputEventMouseMotion && visible && blob.onFloor:
		emit_signal("predict", rotation)
		

func _physics_process(delta):
#	set_scale(Vector2((get_global_mouse_position() - global_position).length()/100, 1))
	if canAim() && !visible:
		visible = true
	elif !canAim() && visible:
		visible = false

	if Input.is_action_just_released("jump") && blob.canJump() && canAim():
		jump()
	if Input.is_action_just_pressed("jump") && blob.canJump() && canAim():
		emit_signal("aim")

	rotation = -ru_getDirection().angle()

func ru_rotation():
	return (get_global_mouse_position() - global_position).angle() - blob.rotation

func canAim():
	if blob.onFloor:
		return ru_getDirection().y > 0.2
	return true

func ru_getDirection():
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	

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
