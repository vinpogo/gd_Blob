extends Area2D

class_name Sector
var planet = preload ("res://objects/mapObjects/Configurable.tscn")
var grid = []
export var PLANET_COUNT = 15
func _ready() -> void:
	randomize()
	var grid_size = 320
	for i in range(PLANET_COUNT):
		var obj_pos = get_free_position_in_grid(grid, Vector2(randi()%8, randi()%8)) * grid_size
		var r = randf() * 1.3+ 0.5
		var o = planet.instance()
		o.set_properties("random", r, obj_pos - Vector2(840, 840))
		$Planets.add_child(o)
func get_free_position_in_grid(grid, pos: Vector2):
	randomize()
	if grid.find(pos) == -1:
		grid.push_back(pos)
		return pos
	else:
		return get_free_position_in_grid(grid, Vector2(randi()%8, randi()%8))
func _process(delta: float) -> void:
	$Sprite.modulate = PlayerManager.get_winning_color()
	$Sprite.modulate.a = 0.3
	pass
func get_blob_statistics():
	var stats = global.stats_proto()

	for planet in $Planets.get_children():
		if planet.isBlobbed > -1:
			stats["player_%s"%planet.isBlobbed] += 1
	return stats
