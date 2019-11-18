extends Node

var player_viewport = preload("res://objects/PlayerViewport.tscn")
onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var minimap = $ViewportContainer/Viewport
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var hud1 = $Viewports/ViewportContainer1/Viewport1/CanvasLayer
onready var world = $Viewports/ViewportContainer1/Viewport1/World

func _ready():

	world.add_players(global.player_count)

	viewport1.size.x = 1024
	minimap.world_2d = viewport1.world_2d
	camera1.target = world.get_node("Player1")
	camera1.connect_signals()
	hud1.target = world.get_node("Player1")
	hud1.world = world
	hud1.player = 1
	hud1.connect_signals()
	if global.player_count == 1:
		$ViewportContainer.rect_position.x = 0.0
		$ViewportContainer.rect_rotation = 0.0
	viewport1.size.x = 1024 / global.player_count
	for i in range(2, global.player_count + 1):
		var v = player_viewport.instance()
		print(v)
		v.get_node("Viewport").size = viewport1.size
		v.get_node("Viewport").world_2d = viewport1.world_2d
		v.get_node("Viewport/Camera2D").target = world.get_node("Player%s"%(i))
		v.get_node("Viewport/Camera2D").connect_signals()
		v.get_node("Viewport/CanvasLayer").target = world.get_node("Player%s"%(i))
		v.get_node("Viewport/CanvasLayer").connect_signals()
		v.get_node("Viewport/CanvasLayer").player = i
		v.get_node("Viewport/CanvasLayer").world = world
		$Viewports.add_child(v)
		world.get_node("Player%s"%(i)).emit_signal("rotate", world.get_node("Player%s"%(i)).compass.up)
	print(world.get_children())


#	world.get_node("Player1").emit_signal("rotate", world.get_node("Player1").compass.up)