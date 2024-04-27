class_name PlayerList extends Node

var _players = {}


func all():
	return _players.values()


func size():
	return _players.size()


func update(new_player_info: PlayerInfo):
	_players[new_player_info.id()] = new_player_info


func by_id(id: int) -> PlayerInfo:
	if _players.has(id):
		return _players[id]
	return


func erase(id: int):
	_players.erase(id)


func get_ready_status() -> bool:
	var result = false
	for player in all():
		result = player.is_ready()
	return result
