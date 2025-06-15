extends Node


var current_player = null
var current_player_pos: Vector2 = Vector2.ZERO

var player_states = {}


func has_player_state(player_name: String):
	return player_name in player_states

func save_player_state(player: Player):
	player_states[player.name] = {
		ammo = player.ammo,
		max_ammo = player.max_ammo,
		grenades = player.grenades,
		max_grenades = player.max_grenades,
		health = player.health,
		max_health = player.max_health,
	}

func load_player_state(player: Player):
	var state = player_states[player.name]
	player.ammo = state.ammo
	player.max_ammo = state.max_ammo
	player.grenades = state.grenades
	player.max_grenades = state.max_grenades
	player.health = state.health
	player.max_health = state.max_health
	
	return state
