extends Sprite
signal aim
signal stopAim
signal jump
signal toggle_zoom
signal bounce
signal flip_gravity
signal pull
signal shoot
signal shield
signal freeze
signal unfreeze

signal move

var ability = {
	"slot_1": "jump",
	"slot_2": "flip_gravity",
	"slot_3": "freeze",
	"slot_4": "jump",
}
var slots_used = []
onready var blob = get_parent()
onready var utils = get_node("/root/global")
func _ready():
	visible = false


func _physics_process(delta):
	handle_inputs()
	rotation = -utils.left_stick().angle()

func canAim():
	if blob.onFloor:
		return utils.left_stick().y > 0.0
	return true

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if !blob.onFloor:
		return
		emit_signal("stopAim")

func handle_inputs() -> void:
	var inputs = utils.ability()
	if inputs.just_pressed.slot_1 || inputs.just_released.slot_1 || inputs.pressed.slot_1:
		handle_slot("slot_1", inputs.just_pressed.slot_1, inputs.just_released.slot_1, inputs.pressed.slot_1)
	if inputs.just_pressed.slot_2 || inputs.just_released.slot_2 || inputs.pressed.slot_2:
		handle_slot("slot_2", inputs.just_pressed.slot_2, inputs.just_released.slot_2, inputs.pressed.slot_2)
	if inputs.just_pressed.slot_3|| inputs.just_released.slot_3 || inputs.pressed.slot_3:
		handle_slot("slot_3", inputs.just_pressed.slot_3, inputs.just_released.slot_3, inputs.pressed.slot_3)
	if inputs.just_pressed.slot_4 || inputs.just_released.slot_4 || inputs.pressed.slot_4:
		handle_slot("slot_4", inputs.just_pressed.slot_4, inputs.just_released.slot_4, inputs.pressed.slot_4)

func handle_slot(slot: String, just_pressed: bool, just_released: bool, pressed: bool):
	if slots_used.find(slot) > -1:
		return
	match(ability[slot]):
		"jump":
			if just_released && canAim():
				unfreeze()
				jump()
				slots_used.append(slot)
				print(slots_used)
			elif just_released && !canAim():
				aim_stop()
			elif just_pressed:
				aim_start()
		"zoom":
			if just_pressed:
				toggleZoom()
		"flip_gravity":
			if just_pressed:
				flip_gravity()
				slots_used.append(slot)
		"freeze":
			print(just_released)
			if just_pressed && !blob.onFloor:
				freeze()
			if just_released:
				print("unfreeze")
				unfreeze()


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
func jump():
	visible = false
	emit_signal("jump")
func toggleZoom():
	emit_signal("toggle_zoom")
func flip_gravity():
	emit_signal("flip_gravity")
func _on_Character_stick() -> void:
	print("reset")
	slots_used = []
