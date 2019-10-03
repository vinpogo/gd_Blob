extends Camera2D

onready var blob = get_parent().get_child(0)
#func _on_ready():
#	rotation = $"../Blob".gravity_dir.angle()-PI/2

func _physics_process(delta):
	global_position = blob.global_position
	