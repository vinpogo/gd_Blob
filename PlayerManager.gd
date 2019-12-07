extends Node

signal score_updated(scores)

var player_count: = 2

var player_configs: = []

var player_scores setget set_player_scores

func set_player_scores(value: Array) -> void:
	player_scores = value
	emit_signal("score_updated", player_scores)

func set_score_for_player(score: int, player_index: int) -> void:
	var tmp = player_scores
	tmp[player_index] = score
	self.player_scores = tmp
func add_score_for_player(score: int, player_index: int) -> void:
	print("add")
	var tmp = player_scores
	tmp[player_index] += score
	self.player_scores = tmp


func default_player_config():
	randomize()
	return {
		"initial_gravity_direction": Vector2(randf(), randf()),
		"color": Color(randf(), randf(), randf()),
		"ability_count": { "jump": 5, "special": 5},
		"player_index": 0,
		"initial_position": Vector2()
	}

func init_n_configs(n: int):
	player_count = n
	player_configs = []
	player_scores = []
	player_scores.resize(n)
	for i in range(player_count):
		var c = default_player_config()
		c.player_index = i
		player_scores[i] = 0
		player_configs.push_back(c)

func get_winning_color() -> Color:
	var max_score_index = player_scores.find(player_scores.max())
	return player_configs[max_score_index].color
