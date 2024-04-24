class_name PlayerList extends Node

var _player_dict: Dictionary

func all() -> Dictionary:
	return _player_dict
	
func count() -> int:
	return _player_dict.size()

func update(new_player_info: PlayerInfo):
	_player_dict[new_player_info.id()] = new_player_info

func get_by_id(id: int) -> PlayerInfo:
	return _player_dict[id]

func clear():
	_player_dict.clear()
