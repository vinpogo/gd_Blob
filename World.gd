extends Node2D

func get_distance_to_goal(player: int):
	var d = get_node("Spawn%s"%( 1 if player == 2 else 2)).global_position - get_node("Player%s"%player).global_position
	return d.length()
	pass

func add_players():
	for player_config in global.player_configs:
		player_config.initial_position = get_node("Spawn%s"%player_config.player_index).global_position
		player_config.initial_gravity_direction = get_node("Spawn%s"%player_config.player_index).initial_gravity
		var b = load("res://objects/newBlob/Blob.tscn").instance()
		b.init_blob(player_config)
		b.set_name("Player%s"%player_config.player_index)
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


func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	if body is BlobCharacter:
		body.compass = global.get_compass("down",-body.global_position)
		body.ru_rotate(body.global_position)