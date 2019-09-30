extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var particle = load("res://objects/player/BlobAim.tscn")
onready var blob = get_parent()
onready var aim = blob.get_node("aim")
var i = 0
var pos = Vector2(0,0)
var lastPos = Vector2(0,0)
onready var grav = Vector2(-1, 0)*blob.GRAVITY
var vel = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = -blob.gravity_dir.angle()
	if i < 40 && visible:
		vel += (-blob.gravity_dir*blob.GRAVITY * delta)
		pos += vel
		if(!get_child(i)):
			print("add")
			var node = particle.instance()
			node.position = pos
			add_child(node)
		else:
			get_child(i).position = pos
		i += 1
	else:
		if visible:
			_on_aim_predict(aim.ru_rotation())


func ru_rotation():
	return (get_global_mouse_position() - global_position).angle() - blob.rotation

func _on_aim_predict(angle):
	vel = Vector2(cos(angle), sin(angle)).normalized()*blob.JUMP_FORCE
	i = 0
	pos = Vector2(0,0)
#	predict_movement(0.05, vel)
	visible = true
	pass # Replace with function body.


func _on_aim_stopPredict():
	print("stop")
	for child in get_children():
		child.queue_free()
#	visible = false
	pass # Replace with function body.
