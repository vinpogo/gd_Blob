extends Button

func _ready():
	grab_focus()


func _on_Restart_button_up() -> void:
	get_tree().change_scene("res://Game.tscn")
