extends Node
var target
var world
var player

onready var count_jump = $CanvasLayer/Container/Columns/Column1/Stats/Values/ValueJump
onready var count_precision = $CanvasLayer/Container/Columns/Column1/Stats/Values/ValuePrecision
onready var count_blob = $CanvasLayer/Container/Columns/Column1/Stats/Values/ValueBlob

func connect_signals():
	target.connect("set_jump_count", self, "_on_Character_set_jump_count")

func _process(delta: float) -> void:
	if world && player && count_blob:
		var stats = world.get_blob_statistics()["player_%s"%player]
		count_blob.text = String(stats)

func _on_Character_set_jump_count(jump_count, precision_count, player) -> void:
	count_jump.text = String(jump_count)
	count_precision.text = String(precision_count)
