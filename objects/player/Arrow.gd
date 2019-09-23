extends Sprite
signal aim
signal jump

var lastPos = Vector2(0,0)
var pos = Vector2(0,0)
var isAiming = false
onready var blob = get_parent()
onready var particle = load("res://objects/player/BlobAim.tscn")
func _ready():
	visible = false

func _input(event):
	if event is InputEventMouseMotion && canAim() && blob.onFloor:
		predict_movement(0.01)
		

func _physics_process(delta):
#	set_scale(Vector2((get_global_mouse_position() - global_position).length()/100, 1))
	if canAim():
		visible = true
	else:
		blob.get_node("aimTimer").stop()
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

func predict_movement(delta):
	print("predict", get_local_mouse_position())
	pos = position
	lastPos = global_position
	var vel = get_local_mouse_position().normalized()*blob.JUMP_FORCE
	var grav = blob.gravity_dir*blob.GRAVITY
	print(vel, grav)
	
	for i in range(50):
		vel += (grav * delta)
		pos += vel
		if(get_child(i) == null):
			print("add")
			var node = particle.instance()
			node.global_position = pos
			add_child(node)
		else:
			get_child(i).position = pos
		lastPos = pos
