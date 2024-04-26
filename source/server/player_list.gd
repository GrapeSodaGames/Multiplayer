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

func erase(id: int):
	_player_dict.erase(id)

func clear():
	_player_dict.clear()

func register_player(new_player_id, new_player_info: PlayerInfo):
	if not new_player_id in all():
		add_child(new_player_info)
		new_player_info.set_player_number(count() + 1)
		new_player_info.set_id(new_player_id)
		_player_dict[new_player_info.id()] = new_player_info
		if multiplayer.is_server():
			new_player_info.set_color(Color(randf(), randf(), randf()))
			new_player_info.set_ready(false)

