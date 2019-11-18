extends MarginContainer
var timer_on = false
func add_duration(t):
	$GridContainer/MarginContainer6/Timer.time_left += t
func update_jump_count():
	$VBoxContainer/GridContainer/MarginContainer8/RichTextLabel.text = String(global.jump_count)
	$VBoxContainer/GridContainer/MarginContainer4/RichTextLabel2.text = String(global.precision_count)
	$VBoxContainer/GridContainer/MarginContainer6/RichTextLabel.text = String(stepify(global.slowmo_duration, 0.01))

func start_slowmo_timer():
	timer_on = true

func stop_slowmo_timer():
	timer_on = false
func _ready():
	stop_slowmo_timer()
func _process(delta: float) -> void:
	update_jump_count()