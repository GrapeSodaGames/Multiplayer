class_name PlayerInfo extends Node
## TODO: Document

# Signals

# Enums

# Exports

# References

# Properties
@export var _player_number: int = 0
@export var _color: Color
@export var _is_ready: bool
@export var _id: int

# Game Loop

# Public Methods

func update(player_info: PlayerInfo):
	assert(player_info.id() == id())
	set_color(player_info.color())
	set_ready(player_info.is_ready())

func id() -> int:
	return _id


func set_id(value: int):
	if value != _id:
		Log.dbg("Updating ID on ", serialize())
		_id = value
		set_authority()


func number() -> int:
	return _player_number


func set_number(value: int):
	if value != number():
		Log.dbg("Updating player number on ", serialize())
		_player_number = value


func color() -> Color:
	return _color


func set_color(value: Color):
	if value != _color:
		Log.dbg("Updating Color on ", serialize())
		_color = value


func is_ready() -> bool:
	return _is_ready


func set_ready(value: bool):
	if value != _is_ready:
		Log.dbg("Updating is_ready on ", serialize())
		_is_ready = value


func is_local_player() -> bool:
	return Server.multiplayer.get_unique_id() == id()


func serialize() -> Dictionary:
	return {"player_number": number(), "color": color(), "is_ready": is_ready(), "id": id()}


static func deserialize(input: Dictionary) -> PlayerInfo:
	var result = PlayerInfo.new()
	result.set_number(input["player_number"])
	result.set_color(input["color"])
	result.set_ready(input["is_ready"])
	return result


func set_authority():
	Log.info("Setting authority to ", id())
	set_multiplayer_authority(id())
# Private Methods

# Events
