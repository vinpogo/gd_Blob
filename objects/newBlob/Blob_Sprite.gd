extends Sprite

onready var blob = get_parent()

func _ready():
	rotation = 0

func _process(delta):
	if !blob.on_floor:
		global_rotation = blob.velocity.angle() + PI/2
	else:
		rotation = 0