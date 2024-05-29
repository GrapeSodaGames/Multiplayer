class_name PlayerInfo extends Node
## TODO: Document

# Signals
signal changed()

# Enums

# Exports

# References
static var _player_info_prefab: PackedScene = preload("res://source/main/player_info.tscn")
# Properties
@export var _player_name: String
@export var _player_number: int
@export var _color: Color
@export var _is_ready: bool
var _id: int

# Game Loop

# Public Methods
func clone() -> PlayerInfo:
	var result = PlayerInfo.new()
	result.set_id(id())
	result.set_number(number())
	result.set_color(color())
	result.set_ready(is_ready())
	return result


func id() -> int:
	return _id


func set_id(value: int):
	if value != _id:
		Log.dbg("Updating ID on " + str(_id) + " from " + str(_id) + " to " + str(value))
		_id = value
		changed.emit()

func player_name() -> String:
	return _player_name

func set_player_name(value: String):
	Log.dbg("Updating name on " + str(_id) + " from " + str(_player_name) + " to " + str(value))
	_player_name = value
	changed.emit()
	
func number() -> int:
	return _player_number


func set_number(value: int):
	if value != _player_number:
		Log.dbg("Updating number on " + str(_id) + " from " + str(_player_number) + " to " + str(value))
		_player_number = value


func color() -> Color:
	return _color


func set_color(value: Color):
	if value != _color:
		Log.dbg("Updating color on " + str(_id) + " from " + str(_color) + " to " + str(value))
		_color = value
		GameState.player_list_changed.emit()


func is_ready() -> bool:
	return _is_ready


func set_ready(value: bool):
	if value != _is_ready:
		Log.dbg("Updating ready on " + str(_id) + " from " + str(_is_ready) + " to " + str(value))
		_is_ready = value
		GameState.player_list_changed.emit()


func is_local_player() -> bool:
	return multiplayer.get_unique_id() == id()


func serialize() -> Dictionary:
	return {"player_name": player_name(), "player_number": number(), "color": color(), "is_ready": is_ready(), "id": id()}


static func deserialize(input: Dictionary) -> PlayerInfo:
	var result: PlayerInfo = _player_info_prefab.instantiate()
	result.set_player_name(input["player_name"])
	result.set_number(input["player_number"])
	result.set_color(input["color"])
	result.set_ready(input["is_ready"])
	result.set_id(input["id"])
	return result

# Private Methods

# Events
