extends Control
var game = preload("res://Game.tscn")
onready var cb_player1 = get_node("MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer/VBoxContainer/CheckBox1")
onready var cb_player2 = get_node("MarginContainer/VBoxContainer/HBoxContainer5/VBoxContainer2/HBoxContainer/VBoxContainer/CheckBox2")
onready var btn_start = $MarginContainer/VBoxContainer/HBoxContainer3/Button
func _ready() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer3/Button.grab_focus()
	pass

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	cb_player2.pressed = !button_pressed


func _on_CheckBox2_toggled(button_pressed: bool) -> void:
	cb_player1.pressed = !button_pressed


func _on_Button_button_up() -> void:
	global.player_count = 1 if cb_player1.pressed else 2
	get_tree().change_scene_to(game)
	pass # Replace with function body.
