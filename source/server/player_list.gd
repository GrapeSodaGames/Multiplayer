class_name PlayerList extends Node

signal player_updated

var _players = {}

func all() -> Dictionary:
	return _players


func by_id(id: int) -> PlayerInfo:
	return _players[id]


func get_ready_status() -> bool:
	var result = false
	for player in _players.values():
		result = player.ready() 	
	return result


func set_player_ready(id: int, value: bool):
	_players[id].set_ready(value)


func set_player_color(id: int, color: Color):
	_players[id].set_color(color)

func update_player(id: int, new_player_info: PlayerInfo):
	_players[id] = new_player_info


func register_player(new_player_id: int, new_player_info: PlayerInfo):
		if not new_player_id in _players:
			Log.info("New Player identified, registering client ", new_player_id)
			new_player_info.set_player_number(_players.size() + 1)
			new_player_info.set_color(Color(randf(), randf(), randf()))
			new_player_info.set_ready(false)
			Log.info("New Player data: ", new_player_info.serialize())
		update_player(new_player_id, new_player_info)
