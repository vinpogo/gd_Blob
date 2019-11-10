extends Node2D

func get_distance_to_goal(player: int):
	var d = get_node("Spawn%s"%( 1 if player == 2 else 2)).global_position - get_node("Player%s"%player).global_position
	return d.length()
	pass


func _on_Player_die(player) -> void:
	get_node("Player%s"%player).global_position = get_node("Spawn%s"%player).global_position

func get_blob_statistics():
	var sectors = $Map.get_children()
	var stats = global.stats_proto()
	for sector in sectors:
		var s = sector.get_blob_statistics()
		for key in stats.keys():
			stats[key] += s[key]
	return stats

func _process(delta: float) -> void:
	print(get_blob_statistics())