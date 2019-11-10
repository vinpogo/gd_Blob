extends Node

onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var viewport2 = $Viewports/ViewportContainer2/Viewport2
onready var minimap = $ViewportContainer/Viewport
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var camera2 = $Viewports/ViewportContainer2/Viewport2/Camera2D
onready var hud1 = $Viewports/ViewportContainer1/Viewport1/CanvasLayer
onready var hud2 = $Viewports/ViewportContainer2/Viewport2/CanvasLayer
onready var world = $Viewports/ViewportContainer1/Viewport1/World

func _ready():
		viewport2.world_2d = viewport1.world_2d
		minimap.world_2d = viewport1.world_2d
		camera1.target = world.get_node("Player1")
		camera1.connect_signals()
		hud1.target = world.get_node("Player1")
		hud1.world = world
		hud1.player = 1
		hud2.player = 2
		hud2.world = world
		hud1.connect_signals()

		camera2.target = world.get_node("Player2")
		camera2.connect_signals()
		hud2.target = world.get_node("Player2")
		hud2.connect_signals()

		world.get_node("Player1").emit_signal("rotate", world.get_node("Player1").compass.up)
		world.get_node("Player2").emit_signal("rotate", world.get_node("Player2").compass.up)