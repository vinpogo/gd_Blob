extends Node2D

func get_distance_to_goal(player: int):
	var d = get_node("Spawn%s"%( 1 if player == 2 else 2)).global_position - get_node("Player%s"%player).global_position
	return d.length()
	pass

func add_players(count: int):
	for i in global.player_count - 1:
		var b = load("res://objects/newBlob/Blob.tscn").instance()
		b.color = Color(randf(), randf(), randf() ,1)
		b.player = i+2
		b.set_name("Player%s"%(i+2))
		add_child(b)
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
