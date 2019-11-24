extends Sprite
signal jump(is_pressed)

signal slot_1(is_pressed)
signal slot_2(is_pressed)
signal slot_3(is_pressed)
signal slot_4(is_pressed)
signal slot_5(is_pressed)

var slots_pressed = [ false, false, false, false, false]

var slots_used = []
onready var blob = get_parent()
onready var utils = get_node("/root/global")
func _ready():
	visible = false

func _physics_process(delta):
	rotation = -utils.left_stick(blob.player).angle()


#func canAim():
#	if blob.onFloor:
#		return utils.left_stick(blob.player).y > 0.0
#	return true
#
#func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
#	if !blob.onFloor:
#		return
#		emit_signal("stopAim")

#func _input(event: InputEvent) -> void:
#	if event.device == blob.player - 1:
#		var signal_to_send = ""
#		var value_to_send
#		if event is InputEventJoypadButton:
#
#			if event.is_action_pressed("ui_home"):
#				get_tree().change_scene("res://objects/Control.tscn")
#
#			if event.is_action_pressed("jump"):
#				signal_to_send = "jump"
#				value_to_send = true
#			if event.is_action_released("jump"):
#				signal_to_send = "jump"
#				value_to_send = false
#
#			if event.is_action_pressed("slot_1"):
#				signal_to_send = "slot_1"
#				value_to_send = true
#			if event.is_action_pressed("slot_2"):
#				signal_to_send = "slot_2"
#				value_to_send = true
#			if event.is_action_pressed("slot_3"):
#				signal_to_send = "slot_3"
#				value_to_send = true
#			if event.is_action_pressed("slot_4"):
#				signal_to_send = "slot_4"
#				value_to_send = true
#			if event.is_action_pressed("slot_5"):
#				signal_to_send = "slot_5"
#				value_to_send = true
#
#			if event.is_action_released("slot_1"):
#				signal_to_send = "slot_1"
#				value_to_send = false
#			if event.is_action_released("slot_2"):
#				signal_to_send = "slot_2"
#				value_to_send = false
#			if event.is_action_released("slot_3"):
#				signal_to_send = "slot_3"
#				value_to_send = false
#			if event.is_action_released("slot_4"):
#				signal_to_send = "slot_4"
#				value_to_send = false
#			if event.is_action_released("slot_5"):
#				signal_to_send = "slot_5"
#				value_to_send = false
#			emit_signal(signal_to_send, value_to_send)
#	pass
