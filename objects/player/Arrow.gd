extends Sprite
signal aim
signal jump

signal move

var isAiming = false
onready var blob = get_parent()


func _ready():
	visible = false


func _physics_process(delta):
	if canAim() && !visible:
		visible = true
	elif !canAim() && visible:
		visible = false
	if Input.is_action_just_released("jump") && blob.canJump() && canAim() && !Input.is_action_pressed("walk"):
		jump()
	elif Input.is_action_just_pressed("jump") && blob.canJump() && canAim() && !Input.is_action_pressed("walk"):
		emit_signal("aim")
	elif Input.is_action_pressed("walk") && blob.onFloor && !Input.is_action_pressed("jump"):
		print("emit walk")
		emit_signal("move")

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
