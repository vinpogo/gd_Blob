extends CanvasLayer
var target
var world
var player

onready var count_jump = $Container/Columns/1/Stats/Values/ValueJump
onready var count_precision = get_node("Container/Columns/1/Stats/Labels/ValuePrecision")
onready var count_blob = get_node("Container/Columns/1/Stats/Labels/ValueBlob")

func connect_signals():
	target.connect("set_jump_count", self, "_on_Character_set_jump_count")

func _process(delta: float) -> void:
	if world && player:
		pass
#		distance_label.bbcode_text = String("[color=#ffffff]%s[/color]"%round(world.get_distance_to_goal(player)))

func _on_Character_set_jump_count(count, player) -> void:
	print(count, count_jump)
#	count_jump.text = String(count)
