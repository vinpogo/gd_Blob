extends Node
var AXIS_THRESHHOLD = 0.5
enum ABILITIES{
	PRECISION_JUMP,
	FLIP_GRAVITY,
	SLOWMO
}
var ability_mapping = {
	"slot_1": ABILITIES.PRECISION_JUMP,
	"slot_2": ABILITIES.FLIP_GRAVITY,
	"slot_3": ABILITIES.SLOWMO
}
func short_angle_dist(from, to):
		var max_angle = PI * 2
		var difference = fmod(to - from, max_angle)
		return fmod(2 * difference, max_angle) - difference

func left_stick():
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_up")- Input.get_action_strength("ui_down")) if Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	Input.get_action_strength("ui_up")- Input.get_action_strength("ui_down")).length() > AXIS_THRESHHOLD else Vector2(0,0)

func ability():
	return {
		"just_pressed": ability_just_pressed(),
		"just_released": ability_just_released(),
		"pressed": ability_pressed()
	}

func ability_just_pressed():
	return {
	"slot_1": Input.is_action_just_pressed("slot_1"),
	"slot_2": Input.is_action_just_pressed("slot_2"),
	"slot_3": Input.is_action_just_pressed("slot_3"),
	"slot_4": Input.is_action_just_pressed("slot_4"),
	}

func ability_just_released():
	return {
	"slot_1": Input.is_action_just_released("slot_1"),
	"slot_2": Input.is_action_just_released("slot_2"),
	"slot_3": Input.is_action_just_released("slot_3"),
	"slot_4": Input.is_action_just_released("slot_4"),
	}
func ability_pressed():
	return {
	"slot_1": Input.is_action_pressed("slot_1"),
	"slot_2": Input.is_action_pressed("slot_2"),
	"slot_3": Input.is_action_pressed("slot_3"),
	"slot_4": Input.is_action_pressed("slot_4"),
	}
func controller_input():
	return {
	"left_stick": left_stick()
	}

func ru_setCompass(dir: String, vec: Vector2 ):
	var v = vec.normalized()
	match(dir):
		"up":
			return {
				"up": v, "down": -v, "right": v.rotated(PI/2), "left": v.rotated(-PI/2)
			}
		"down":
			return {
				"up": -v, "down": v, "right": v.rotated(-PI/2), "left": v.rotated(PI/2)
			}
		"right":
			return {
				"up": v.rotated(-PI/2), "down": v.rotated(PI/2), "right": v, "left": -v
			}
		"left":
			return {
				"up": v.rotated(PI/2), "down": v.rotated(-PI/2), "right": -v, "left": v
			}