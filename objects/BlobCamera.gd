extends Camera2D

func _ready():
	zoom = zoom*3

func _physics_process(delta):
	if Input.is_action_just_pressed("slot_5"):
		zoom = zoom*3 if zoom == Vector2(1, 1) else Vector2(1, 1)

func lerp_angle(from, to, weight):
		return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
		var max_angle = PI * 2
		var difference = fmod(to - from, max_angle)
		return fmod(2 * difference, max_angle) - difference

func _on_Blob_toggle_zoom() -> void:
	zoom = zoom*2 if zoom == Vector2(1, 1) else Vector2(1, 1)


func _on_Character_toggle_zoom() -> void:
	zoom = zoom*2 if zoom == Vector2(1, 1) else Vector2(1, 1)


func _on_Character_rotate(vec) -> void:
	var angle = vec.angle()
	var rot = rotation - PI / 2
