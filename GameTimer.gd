extends Label

func _process(delta: float) -> void:
	if $"../../Timer":
		var t = stepify($"../../Timer".time_left, 1)
		var mins = floor(t/60)
		var secs = t -  60*mins
		text = String(mins) + ":" + String(secs)
