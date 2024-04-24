class_name ConnectionMananger extends Node

# Properties
const MAX_PLAYERS = 4
@export var _server_port = 25555
var _ip: String


# Game Loop
func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	multiplayer.multiplayer_peer = null


# Methods
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
	Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), Server.player_info.serialize())


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
	Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), Server.player_info.serialize())


func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	Server.players = {}


func get_server_ip() -> String:
	Log.dbg("Server ip is ", _ip)
	return _ip


func is_peer_connected() -> bool:
	return multiplayer.multiplayer_peer != null


## Events
func _on_peer_connected(_id):
	pass


func _on_peer_disconnected(id):
	Log.info("ConnectionManager received _on_peer_disconnected from ", id)
	Log.info("data being erased", Server.get_player(id).serialize())
	Server.players.erase(id)
	Server.player_disconnected.emit(id)


func _on_connected_to_server():
	Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), Server.player_info.serialize())


func _on_connection_failed():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	Server.players.clear()
	Server.server_disconnected.emit()
