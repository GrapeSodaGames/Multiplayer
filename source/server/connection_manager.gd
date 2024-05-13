class_name ConnectionManager extends Node
## TODO: Document

# Signals

# Enums

# Exports

# References

# Properties
const MAX_PLAYERS = 4
var _server_port = 25555
var _ip: String

# Game Loop
func _ready():
	_connect_server_signals()
	_connect_client_signals()
	

	multiplayer.multiplayer_peer = null


# Public Methods
func create_server(port):
	Log.info("Creating server as host")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, MAX_PLAYERS)
	if error:
		Log.warn("Encountered Error: " + str(error))
		return error
	multiplayer.multiplayer_peer = peer
	_ip = "localhost"
	_server_port = port
	Server.connection_success.emit()


# TODO: Code Smell - Long Method
func connect_to_server(new_ip, port):
	Log.info("Connecting to server at ", new_ip)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(new_ip, port)
	if error == ERR_CANT_CREATE:
		Log.warn("Could not connect to server at ", str(new_ip) + ":" + str(port))
		Server.connection_failed.emit()
		return
	multiplayer.multiplayer_peer = peer
	Log.info("Successfully connected to server")
	_ip = new_ip
	_server_port = port
	Server.connection_success.emit()


func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	Server.get_players().clear()


func get_server_ip() -> String:
	Log.dbg("Server ip is ", _ip)
	return _ip


func is_peer_connected() -> bool:
	return multiplayer.multiplayer_peer != null


# Private Methods
func _connect_server_signals():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func _connect_client_signals():
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


# Events
func _on_peer_connected(id):
	Log.info(str(multiplayer.get_unique_id())+ ": New player connected from ", id)
	var player: PlayerInfo = Server.get_player_info_prefab().instantiate()
	player.set_id(id)
	Server.get_players().update(player)


func _on_peer_disconnected(id):
	Log.info(str(multiplayer.get_unique_id())+ " received peer_disconnected from ", id)
	Server.get_players().erase(id)
	Server.player_disconnected.emit(id)


func _on_connected_to_server():
	Log.info(str(multiplayer.get_unique_id())+ ": Connection to server successful")
	Server.get_players().register(multiplayer.get_unique_id())


func _on_connection_failed():
	Log.info(str(multiplayer.get_unique_id())+ ": Connection to server failed")
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	Log.info(str(multiplayer.get_unique_id())+ ": Server disconnected")
	multiplayer.multiplayer_peer = null
	Server.get_players().clear()
	Server.server_disconnected.emit()
