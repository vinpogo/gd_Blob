extends Node
class_name PlayerController


signal B_PRESSED

var index : int = 1

func init(playerIndex: int) -> void:
	index = playerIndex
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton && index == event.device:
		if event.button_index == 0:
			emit_signal("B_PRESSED")
		print("button ", event.button_index, " pressed or released for player ", index)
	if event is InputEventJoypadMotion && index == event.device:
		print("joystickmoved for player ", index)