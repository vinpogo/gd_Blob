extends Area2D

class_name Sector
var planet = preload ("res://objects/mapObjects/Configurable.tscn")
var grid = []
var leader = ""
export var PLANET_COUNT = 100
func _ready() -> void:
	randomize()
	var shape = $CollisionShape2D.shape.extents
	var grid_size = 400
	for i in range(PLANET_COUNT):
		var obj_pos = get_free_position_in_grid(grid, Vector2(randi()%5, randi()%5)) * grid_size
		var r = randf() * 1.5+ 0.5
		var o = planet.instance()
		o.set_properties("random", r, obj_pos)
		$Planets.add_child(o)
func get_free_position_in_grid(grid, pos: Vector2):
	if grid.find(pos) == -1:
		grid.push_back(pos)
		return pos
	else:
		return get_free_position_in_grid(grid, Vector2(randi()%5, randi()%5))
func _process(delta: float) -> void:
	$Sprite.modulate = global.get_winning_color(get_blob_statistics())
	pass
func get_blob_statistics():
	var stats = global.stats_proto()

	for planet in $Planets.get_children():
		if planet.isBlobbed > -1:
			stats["player_%s"%planet.isBlobbed] += 1
	return stats
