class_name PlayerList extends Node
## TODO: Document

# Signals

# Enums

# Exports

# References

# Properties
var _players = {}

# Game Loop

# Public Methods

func all():
	return _players.values()


func size():
	return _players.size()


func update(new_player_info: PlayerInfo):
	var new_id = new_player_info.id()
	if new_id < 1:
		return
	
	var existing_player: PlayerInfo = by_id(new_id)
	if existing_player:
		if existing_player.color() != new_player_info.color():
			Log.info("Updating player " + str(new_player_info.id()) + " color" )
			_players[new_player_info.id()] = new_player_info
	else:
		Log.info("Update creating new player ", new_player_info.id())
		_players[new_player_info.id()] = new_player_info


func by_id(id: int) -> PlayerInfo:
	if _players.has(id):
		return _players[id]
	return


func by_number(number: int) -> PlayerInfo:
	for player: PlayerInfo in _players:
		if player.number() == number:
			return player
	return


func erase(id: int):
	_players.erase(id)


func clear():
	_players = {}


func get_ready_status() -> bool:
	var result = false
	for player in all():
		result = player.is_ready()
	return result

# Private Methods

# Events
