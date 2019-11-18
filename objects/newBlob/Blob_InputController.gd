extends Sprite
signal aim
signal stopAim
signal precision_jump
signal jump
signal toggle_zoom
signal bounce
signal flip_gravity
signal pull
signal shoot
signal shield
signal freeze
signal unfreeze
signal slowmo

signal move

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
	handle_inputs()
	rotation = -utils.left_stick(blob.player).angle()


func canAim():
	if blob.onFloor:
		return utils.left_stick(blob.player).y > 0.0
	return true

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if !blob.onFloor:
		return
		emit_signal("stopAim")

func _input(event: InputEvent) -> void:
	if event.device == blob.player - 1:
		var signal_to_send = ""
		var value_to_send
		if event is InputEventJoypadButton:

			if event.is_action_pressed("ui_home"):
				get_tree().change_scene("res://objects/Control.tscn")

			if event.is_action_pressed("jump"):
				emit_signal("jump")
				return

			if event.is_action_pressed("slot_1"):
				signal_to_send = "slot_1"
				value_to_send = true
			if event.is_action_pressed("slot_2"):
				signal_to_send = "slot_2"
				value_to_send = true
			if event.is_action_pressed("slot_3"):
				signal_to_send = "slot_3"
				value_to_send = true
			if event.is_action_pressed("slot_4"):
				signal_to_send = "slot_4"
				value_to_send = true
			if event.is_action_pressed("slot_5"):
				signal_to_send = "slot_5"
				value_to_send = true

			if event.is_action_released("slot_1"):
				signal_to_send = "slot_1"
				value_to_send = false
			if event.is_action_released("slot_2"):
				signal_to_send = "slot_2"
				value_to_send = false
			if event.is_action_released("slot_3"):
				signal_to_send = "slot_3"
				value_to_send = false
			if event.is_action_released("slot_4"):
				signal_to_send = "slot_4"
				value_to_send = false
			if event.is_action_released("slot_5"):
				signal_to_send = "slot_5"
				value_to_send = false
			print(signal_to_send, " ,", value_to_send)
			emit_signal(signal_to_send, value_to_send)
	pass

func handle_inputs() -> void:


#	if Input.is_action_just_pressed("jump_%s" % blob.player):
#		emit_signal("jump")
	if(Input.is_action_just_pressed("slowmo_%s" % blob.player)):
		slowmo(true)
	if(Input.is_action_just_released("slowmo_%s" % blob.player)):
		slowmo(false)
	var inputs = utils.ability(blob.player)
	if inputs.just_pressed.slot_1 || inputs.just_released.slot_1 || inputs.pressed.slot_1:
		handle_slot("slot_1", inputs.just_pressed.slot_1, inputs.just_released.slot_1, inputs.pressed.slot_1)
	if inputs.just_pressed.slot_2 || inputs.just_released.slot_2 || inputs.pressed.slot_2:
		handle_slot("slot_2", inputs.just_pressed.slot_2, inputs.just_released.slot_2, inputs.pressed.slot_2)
	if inputs.just_pressed.slot_3|| inputs.just_released.slot_3 || inputs.pressed.slot_3:
		handle_slot("slot_3", inputs.just_pressed.slot_3, inputs.just_released.slot_3, inputs.pressed.slot_3)


func handle_slot(slot: String, just_pressed: bool, just_released: bool, pressed: bool):
	if slots_used.find(slot) > -1:
		return
	match(global.ability_mapping[slot]):
		global.ABILITIES.PRECISION_JUMP:
			if just_released && canAim():
				unfreeze()
				precision_jump()
				slots_used.append(slot)
			elif just_released && !canAim():
				aim_stop()
			elif just_pressed:
				aim_start()
		"zoom":
			if just_pressed:
				toggleZoom()
		global.ABILITIES.FLIP_GRAVITY:
			if just_pressed:
				flip_gravity()
				slots_used.append(slot)

func slowmo(b: bool):
	emit_signal("slowmo", b)
func freeze():
	emit_signal("freeze")
func unfreeze():
	emit_signal("unfreeze")
	slots_used.append("freeze")
func aim_start():
	visible = true
	emit_signal("aim")
func aim_stop():
	visible = false
	emit_signal("stopAim")
func precision_jump():
	visible = false
	emit_signal("precision_jump")
func toggleZoom():
	emit_signal("toggle_zoom")
func flip_gravity():
	emit_signal("flip_gravity")
func _on_Character_stick() -> void:
	slots_used = []
