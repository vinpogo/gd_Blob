extends Button

func _ready():
	pass


func _on_Menu_button_up() -> void:
	get_tree().change_scene("res://objects/Control.tscn")
