extends Sprite
signal aim
signal stopAim
signal jump

signal move

var isAiming = false
onready var blob = get_parent()
var controller_offset = {"up": 0, "down": 0, "right": 0, "left": 0}

func _on_ready():
	visible = false



func _physics_process(delta):
#	if Input.is_action_just_pressed("debug"):
#		controller_offset.up = Input.get_action_strength("ui_up")
#		controller_offset.down = Input.get_action_strength("ui_down")
#		controller_offset.left = Input.get_action_strength("ui_left")
#		controller_offset.right = Input.get_action_strength("ui_right")
	if canAim() && !visible:
		visible = true
	elif !canAim() && visible:
		visible = false
	elif Input.is_action_just_released("jump") && canAim():
		print("emit jump")
		jump()
	elif Input.is_action_just_released("jump") && !canAim():
		emit_signal("stopAim")
	elif Input.is_action_just_pressed("jump") && blob.jump_count < blob.MAX_JUMPS:
		emit_signal("aim")
	rotation = -ru_getDirection().angle()

func ru_rotation():
	return (get_global_mouse_position() - global_position).angle() - blob.rotation

func canAim():
	if blob.onFloor:
		return ru_getDirection().y > 0.0 && ru_getDirection().length() > 0.5
	elif !blob.onFloor && ru_getDirection().length() > 0.5 && blob.jump_count < blob.MAX_JUMPS:
		return true
	return false

func ru_getDirection():
	return Vector2(Input.get_action_strength("ui_right")-controller_offset.right - Input.get_action_strength("ui_left")+controller_offset.left,
	Input.get_action_strength("ui_up")-controller_offset.up - Input.get_action_strength("ui_down")+controller_offset.down)


func startAim():
		visible = true
		isAiming = true
func stopAim():
		visible = false
		isAiming = false
func jump():
	emit_signal("jump")
func move():
	emit_signal("move")

func crossProduct(vec1, vec2):
	var a = vec1.normalized()
	var b = vec2.normalized()
	return a.x * b.y - a.y * b.x


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	emit_signal("stopAim")
	pass # Replace with function body.
