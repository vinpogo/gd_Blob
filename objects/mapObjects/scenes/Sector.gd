extends Area2D

class_name Sector
var planet = preload ("res://objects/mapObjects/Configurable.tscn")
export var PLANET_COUNT = 100
func _ready() -> void:
	randomize()
	var shape = $CollisionShape2D.shape.extents
	for i in range(PLANET_COUNT):
		var obj_pos = Vector2(randf()*2*shape.x-shape.x, randf()*2*shape.y - shape.y)
		var r = randf() * 1.5+ 0.5
		var o = planet.instance()
		o.set_properties("random", r, obj_pos)
		$Planets.add_child(o)

func get_blob_statistics():
	var stats = global.stats_proto()

	for planet in $Planets.get_children():
		if planet.isBlobbed > 0:
			stats["player_%s"%planet.isBlobbed] += 1
	return stats
