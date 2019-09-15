extends StaticBody2D

onready var ru_collider = get_node("CollisionShape2D")

signal stick

func get_type():
	return "sticky"