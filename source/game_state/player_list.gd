class_name PlayerList extends MultiplayerSpawner
## TODO: Document

# Signals

# Enums

# Exports

# References

# Properties

# Game Loop
func _init():
	spawn_function = _spawn_player

func _process(delta):
	GameState.player_list_changed.emit()

# Public Methods

func all():
	return get_children()


func size():
	return get_child_count()

func register(new_player_info: PlayerInfo):
	if GameState.is_host():
		new_player_info.set_number(size() + 1)
		Log.info("Registering new player...")
		spawn(new_player_info.serialize())
	GameState.player_list_changed.emit()
		

#func update(new_player_info: PlayerInfo):
	#var new_id = new_player_info.id()
	#if new_id < 1:
		#return
	#
	#var existing_player: PlayerInfo = by_id(new_id)
	#if existing_player:
		#if existing_player.color() != new_player_info.color():
			#Log.info("Updating player " + str(new_player_info.id()) + " color" )
			#_players[new_player_info.id()] = new_player_info
		#if existing_player.is_ready() != new_player_info.is_ready():
			#_players[new_player_info.id()] = new_player_info
	#else:
		#Log.info("Update creating new player ", new_player_info.id())
		#_players[new_player_info.id()] = new_player_info
	#
#

func by_id(id: int) -> PlayerInfo:
	for player: PlayerInfo in all():
		if player.id() == id:
			return player
	return


func by_number(number: int) -> PlayerInfo:
	if size() < number - 1:
		return
	for player: PlayerInfo in all():
		if player.number() == number:
			return player
	return

func local() -> PlayerInfo:
	for player: PlayerInfo in all():
		if player.is_local_player():
			return player
	return

func erase(id: int):
	for player: PlayerInfo in all():
		if player.id() == id:
			player.queue_free()


func clear():
	for player: PlayerInfo in all():
		player.queue_free()


func get_ready_status() -> bool:
	var result = false
	for player: PlayerInfo in all():
		result = player.is_ready()
	return result

# Private Methods

	

# Events
func _spawn_player(info: Dictionary) -> PlayerInfo:
	var player = PlayerInfo.deserialize(info)
	Log.info("Spawning new player ", player.id())
	player.name = str(player.id())
	player.set_multiplayer_authority(player.id())
	return player
