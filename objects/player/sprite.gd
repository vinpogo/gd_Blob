extends AnimatedSprite

onready var blob = get_parent()

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if !blob.onFloor:
		rotation = 0
		global_rotation = blob.velocity.angle() +PI/2
	else:
		global_rotation = 0
		rotation = PI/2
