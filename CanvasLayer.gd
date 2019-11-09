extends CanvasLayer
var target
var world
var player
onready var jump_count = $RichTextLabel
onready var distance_label = $RichTextLabel2

func connect_signals():
	target.connect("set_jump_count", self, "_on_Character_set_jump_count")

func _process(delta: float) -> void:
	if world && player:
		distance_label.bbcode_text = String("[color=#ffffff]%s[/color]"%world.get_distance_to_goal(player))

func _on_Character_set_jump_count(count, player) -> void:
	jump_count.bbcode_text = String("[color=#ffffff]%s[/color]"%count)
