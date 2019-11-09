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
var precision_count = 5
var slowmo_duration = 5.0
func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func left_stick(player: int):
	if Input.get_connected_joypads().size() > 0:
		var x_Axis = Input.get_joy_axis(player - 1, JOY_AXIS_0)
		var y_Axis = -Input.get_joy_axis(player - 1, JOY_AXIS_1)
		return Vector2(x_Axis, y_Axis) if Vector2(x_Axis, y_Axis).length() > AXIS_THRESHHOLD else Vector2(0,0)

func ability(player: int):
	return {
		"just_pressed": ability_just_pressed(player),
		"just_released": ability_just_released(player),
		"pressed": ability_pressed(player)
	}

func ability_just_pressed(player: int):
	return {
	"slot_1": Input.is_action_just_pressed("slot_1_%s"%player),
	"slot_2": Input.is_action_just_pressed("slot_2_%s"%player),
	"slot_3": Input.is_action_just_pressed("slot_3_%s"%player),
	}

func ability_just_released(player: int):
	return {
	"slot_1": Input.is_action_just_released("slot_1_%s"%player),
	"slot_2": Input.is_action_just_released("slot_2_%s"%player),
	"slot_3": Input.is_action_just_released("slot_3_%s"%player),
	}
func ability_pressed(player: int):
	return {
	"slot_1": Input.is_action_pressed("slot_1_%s"%player),
	"slot_2": Input.is_action_pressed("slot_2_%s"%player),
	"slot_3": Input.is_action_pressed("slot_3_%s"%player),
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
