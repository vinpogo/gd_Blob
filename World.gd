extends Node2D

var b = preload("res://objects/newBlob/Blob.tscn")
var obj = preload ("res://objects/mapObjects/Configurable.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Input.get_connected_joypads(), "pads")
	var pos = get_node("Spawnpoint").position
	var blob = b.instance()
	blob.global_position = pos
	add_child(blob)
	var shape = $GameZone/CollisionShape2D.shape.extents
	print(floor(shape.x*shape.y / 300000))
	for i in range(floor(shape.x*shape.y / 100000)):
		var obj_pos = Vector2(randf()*shape.x - shape.x/2, randf()*shape.y - shape.y/2)
		var o = obj.instance()
		var r = randf() * 2+ 0.2
		o.global_position = obj_pos
		o.scale =Vector2(r, r)
		o.rotation = randf() *2 * PI
		o.set_type()
		add_child(o)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta: float) -> void:
	print()
	if $Character:
		$CanvasLayer/RichTextLabel.text = String(stepify((- $Character.global_position + $Configurable2.global_position).length()-600, 1))