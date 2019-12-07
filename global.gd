extends Node
const AXIS_THRESHHOLD = 0.5
var player_count = 2

var player_configs = []

func default_player_config():
	randomize()
	return {
		"initial_gravity_direction": Vector2(randf(), randf()),
		"color": Color(randf(), randf(), randf()),
		"ability_count": { "jump": 5, "special": 5}
	}

func init_n_configs(n: int):
	player_configs = []
	for i in range(n):
		var c = default_player_config()
		c.player_index = i
		player_configs.push_back(c)

func init_player_config_n(n: int, config = null):
	if config:
		player_configs[n] = config

func get_player_config(player_index: int):
	return player_configs[player_index]

func stats_proto():
	var s = {}
	for i in range(player_count):
		s["player_%s"%(i)] = 0
	return s

func get_winning_color(stats):
	var tmp_max = 0
	var c = Color(1,1,1)
	for i in stats.size():
		if stats["player_%s"%i] > tmp_max:
			tmp_max = stats["player_%s"%i]
			c = player_configs[i].color
	return c
	pass

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func left_stick(player: int) -> Vector2:
	var x_Axis = Input.get_joy_axis(player, JOY_AXIS_0)
	var y_Axis = Input.get_joy_axis(player, JOY_AXIS_1)
	return Vector2(x_Axis, y_Axis).normalized() if Vector2(x_Axis, y_Axis).length() > AXIS_THRESHHOLD else Vector2(0,0)

func get_compass(dir: String, vec: Vector2 ):
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
