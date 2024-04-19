class_name PlayerInfo extends Node

var _player_number: int
var _color: Color
var _is_ready: bool

func number() -> int:
	return _player_number

func set_player_number(value: int):
	_player_number = value

func color() -> Color:
	return _color

func set_color(value: Color):
	_color = value

func is_ready() -> bool:
	return _is_ready

func set_ready(value: bool):
	_is_ready = value

func serialize() -> Dictionary:
	return {"player_number": number(), "color": color(), "is_ready": is_ready()}


static func deserialize(input: Dictionary) -> PlayerInfo:
	var result = PlayerInfo.new()
	result.set_player_number(input["player_number"])
	result.set_color(input["color"])
	result.set_ready(input["is_ready"])
	return result
