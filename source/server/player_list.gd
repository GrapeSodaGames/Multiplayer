class_name PlayerList extends Node
## TODO: Document

# Signals

# Enums

# Exports

# References

# Properties

# Game Loop

# Public Methods

func all():
	return get_children()


func size():
	return get_child_count()

@rpc
func register(new_id: int):
	Log.info("Registering new player ", new_id)
	var player:PlayerInfo = Server.get_player_info_prefab().instantiate()
	player.set_id(new_id)
	if Server.is_host():
		player.set_number(size() + 1)
		player.set_color(Color(randf(), randf(), randf()))
		player.set_ready(false)
		player.name = str(player.id())
	add_child(player, true)

func update(new_player_info: PlayerInfo):
	if new_player_info.id() < 1:
		return
		
	var existing_player: PlayerInfo = by_id(new_player_info.id())
	
	if existing_player:
		Log.info("Updating existing player ", new_player_info.id())
		existing_player.update(new_player_info)
	else:
		Log.info("Attempting to update non-existent player ", new_player_info.id())
		register(new_player_info.id())
	


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


func erase(id: int):
	by_id(id).queue_free()


func clear():
	for child in all():
		child.queue_free()


func get_ready_status() -> bool:
	var result = false
	for player in all():
		result = player.is_ready()
	return result

# Private Methods

		
		
# Events
