class_name GSGGameState extends Node
## Autoloaded.  Responsible for managing connections and the player list

# Signals

# to Lobby GUI
signal player_list_changed
signal connection_failed
signal connection_succeeded

signal game_ended
signal game_error(what)

# Enums

# Exports
@export var port: int = 25555
@export var max_peers: int = 4

# Properties
var peer: MultiplayerPeer

# References
var _local_config := LocalConfig.new()
@onready var local_player: PlayerInfo = %LocalPlayer
@onready var players: PlayerList = %Players
@onready var conn_timer: Timer = %ConnectionCheckTimer

# Game Loop
func _ready():
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_ok)


# Public Methods
func host_game(new_player_name: String):
	Log.info("Creating new Host...")
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_peers)
	multiplayer.set_multiplayer_peer(peer)
	set_up_local_player(new_player_name)
	register_player(local_player.serialize())
	Log.info("Game Successfully Hosted")
	connection_succeeded.emit()


func join_game(ip: String, new_player_name: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.set_multiplayer_peer(peer)
	set_up_local_player(new_player_name)


func is_peer_connected() -> bool:
	Log.dbg("Checking peer type: " + type_string(typeof(peer)) + " (" + str(typeof(peer)) + ")")
	return peer != null


func is_host() -> bool:
	if is_peer_connected():
		return multiplayer.is_server()
	return false


func get_players() -> PlayerList:
	return players


func local_config() -> LocalConfig:
	return _local_config


func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	peer = null


# Private Methods
func set_up_local_player(new_player_name: String):
	local_player.set_id(peer.get_unique_id())
	local_player.set_player_name(new_player_name)
	local_player.set_color(Color.from_ok_hsl(randf(), randf_range(0.25, 1.0), 0.5))

@rpc("any_peer")
func register_player(new_player_info: Dictionary):
	var id = multiplayer.get_remote_sender_id()
	if id == 0:
		id = 1
	var new_player = PlayerInfo.deserialize(new_player_info)
	Log.info("Registering player " + new_player.player_name() + " at " + str(id))
	new_player.set_id(id)
	new_player.name = str(id)
	players.register(new_player)

func unregister_player(id: int):
	Log.info("Unregistering ", id)
	players.erase(id)
	player_list_changed.emit()


@rpc("call_local")
func load_world():
	var world = load("res://source/world/world.tscn").instantiate()
	get_tree().get_root().add_child(world)


func begin_game():
	assert(multiplayer.is_server())
	load_world.rpc()


func end_game():
	game_ended.emit()
	#multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	peer = null
	if has_node("/root/World"):
		get_node("/root/World").queue_free()
	players.clear()


# Events
func _player_connected(id: int):
	Log.info("Connection successful from ID " + str(id))
	Log.dbg("Local Player Info: ", local_player)
	register_player.rpc_id(id, local_player.serialize())
	connection_succeeded.emit()


func _player_disconnected(id: int):
	game_error.emit("Player " + str(id) + " disconnected")
	if id == 1:
		end_game()
	else:
		unregister_player(id)


func _connected_ok():
	Log.info("Received connection_succeeded signal")
	connection_succeeded.emit()


func _on_connection_check_timer_timeout():
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		end_game()

