extends Node2D

func get_distance_to_goal(player: int):
	var d = get_node("Spawn%s"%( 1 if player == 2 else 2)).global_position - get_node("Player%s"%player).global_position
	return d.length()
	pass

func add_players(count: int):
	for i in global.player_count:
		var b = load("res://objects/newBlob/Blob.tscn").instance()
		b.init_blob(i+1, Vector2(200 * i , 200 * i))
#		b.color = Color(randf(), randf(), randf() ,1)
#		b.player = i+1
		b.set_name("Player%s"%(i+1))
#		b.initial_gravity = Vector2(0,1)
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
