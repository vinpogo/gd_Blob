extends Node2D

var planet = preload ("res://objects/mapObjects/Configurable.tscn")

func get_distance_to_goal(player: int):
	var d = get_node("Spawn%s"%( 1 if player == 2 else 2)).global_position - get_node("Player%s"%player).global_position
	return d.length()
	pass

func _ready():
	randomize()
	var shape = $GameZone/CollisionShape2D.shape.extents
	for i in range(floor(shape.x*shape.y / 100000)):
		var obj_pos = Vector2(randf()*2*shape.x-shape.x, randf()*2*shape.y - shape.y)
		var r = randf() * 2+ 0.2
		var o = planet.instance()
		o.set_properties("random", r, obj_pos)

		o.global_position = obj_pos
		o.scale =Vector2(r, r)
		o.rotation = randf() *2 * PI
		o.set_type()
		add_child(o)


func _on_Player_die(player) -> void:
	get_node("Player%s"%player).global_position = get_node("Spawn%s"%player).global_position

	pass # Replace with function body.
