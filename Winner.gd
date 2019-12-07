extends Sprite

func _ready():
	modulate = PlayerManager.get_winning_color()
	pass
