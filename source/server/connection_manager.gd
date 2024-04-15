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


# TODO: Code Smell - Long Method
func create_server():
	Log.info("Creating server as host")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(_server_port, MAX_PLAYERS)
	if error:
		UI.debug_log.write("Encountered Error: " + str(error))
		return error
	multiplayer.multiplayer_peer = peer
	_ip = "localhost"
	Server.connection_success.emit()
	Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), Server.player_info)


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
	Server.connection_success.emit()
	Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), Server.player_info)


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
	Server.players.erase(id)
	Server.player_disconnected.emit(id)
	UI.set_ui_state(GSGUI.UIState.MAIN_MENU)


func _on_connected_to_server():
	Server.send_player_info.rpc_id(1, multiplayer.get_unique_id(), Server.player_info)


func _on_connection_failed():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	Server._players.clear()
	Server.server_disconnected.emit()