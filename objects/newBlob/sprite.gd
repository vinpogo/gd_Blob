extends AnimatedSprite

onready var blob = get_parent()

func _ready():
	rotation = 0
	
func _physics_process(delta):
	if !blob.onFloor:
		global_rotation = blob.velocity.angle() + PI/2
	else:
		rotation = 0