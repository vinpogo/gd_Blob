extends Node2D

var b = preload("res://objects/newBlob/Blob.tscn")
var obj = preload ("res://objects/mapObjects/Configurable.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var pos = get_node("Spawnpoint").position
	var blob = b.instance()
	blob.global_position = pos
	add_child(blob)

	for i in range(100):
		var obj_pos = Vector2(randf()*5800 - 2900, randf()*3000 - 1500)
		var o = obj.instance()
		var r = randf() * 2
		o.global_position = obj_pos
		o.scale =Vector2(r, r)

		o.rotation = randf() *2 * PI
		add_child(o)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
