class_name PlayerInfo extends Node

var _player_number: int
var _color: Color
var _is_ready: bool
var _id: int

func id() -> int:
	return _id

func set_id(value: int):
	if value != _id:
		_id = value

func number() -> int:
	return _player_number

func set_number(value: int):
	if value != _player_number:
		_player_number = value

func color() -> Color:
	return _color

func set_color(value: Color):
	if value != _color:
		_color = value

func is_ready() -> bool:
	return _is_ready

func set_ready(value: bool):
	if value != _is_ready:
		_is_ready = value

func serialize() -> Dictionary:
	return {"player_number": number(), "color": color(), "is_ready": is_ready(), "id": id()}


static func deserialize(input: Dictionary) -> PlayerInfo:
	var result = PlayerInfo.new()
	result.set_number(input["player_number"])
	result.set_color(input["color"])
	result.set_ready(input["is_ready"])
	result.set_id(input["id"])
	return result

