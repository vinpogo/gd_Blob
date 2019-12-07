extends Node
var target
var world
var player

onready var count_jump = $CanvasLayer/Container/Columns/Column1/Stats/Values/ValueJump
onready var count_special = $CanvasLayer/Container/Columns/Column1/Stats/Values/ValueSpecial
onready var count_blob = $CanvasLayer/Container/Columns/Column1/Stats/Values/ValueBlob
onready var count_score = $CanvasLayer/Container/Columns/Column1/Stats/Values/ValueScore

func _ready() -> void:
	PlayerManager.connect("score_updated", self, "_on_score_updated")

func connect_signals():
	target.connect("set_jump_count", self, "_on_Character_set_jump_count")

func _process(delta: float) -> void:
	if world && player > -1 && count_blob:
		var stats = world.get_blob_statistics()["player_%s"%player]
		count_blob.text = String(stats)

func _on_score_updated(player_scores) -> void:
	print("score_")
	count_score.text = String(player_scores[player])
	pass

func _on_Character_set_jump_count(ability_count, player) -> void:
	count_jump.text = String(ability_count.jump)
	count_special.text = String(ability_count.special)
