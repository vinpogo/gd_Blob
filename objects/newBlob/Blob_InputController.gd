extends Sprite

onready var blob = get_parent()
func _ready():
	visible = false

func _physics_process(delta):
	rotation = global.left_stick(blob.player).angle()
