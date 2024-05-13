class_name GSGServer extends Node
## TODO: Document

# Signals
signal connection_success
signal connection_failed
signal server_disconnected
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)


# Enums
enum ServerStatus { DISCONNECTED, HOST, GUEST }

# Exports

# References
var _player_info_prefab: PackedScene = preload("res://source/player_info.tscn")
@onready var _players: PlayerList = get_node("PlayerList")

# Properties
@onready var _connection_manager: ConnectionManager = get_node("ConnectionManager")


# Game Loop
func _init():
	Log.dbg("Server Initializing...")
	
	Log.dbg("Server Initialized")


func _ready():
	
	UI.request_create_new_server_signal.connect(_on_request_create_new_server)
	UI.request_connect_to_server_signal.connect(_on_request_connect)
	UI.request_disconnect_from_server_signal.connect(_on_request_disconnect)


# Public Methods
func get_player_info_prefab() -> PackedScene:
	return _player_info_prefab

func get_players() -> PlayerList:
	return _players


func get_player(id: int) -> PlayerInfo:
	return _players.by_id(id)


func get_local_player() -> PlayerInfo:
	for player: PlayerInfo in get_players().all():
		if player.is_local_player():
			return player
	return
	
func is_peer_connected() -> bool:
	if _connection_manager:
		return _connection_manager.is_peer_connected()
	return false


func is_host() -> bool:
	if is_peer_connected():
		return multiplayer.is_server()
	return false


func connection_manager() -> ConnectionManager:
	return _connection_manager


# Private Methods


# Events
func _on_request_connect(ip, port):
	Log.info("Server received request to connect to server")
	_connection_manager.connect_to_server(ip, port)


func _on_request_create_new_server(port):
	Log.info("Server received request to create a server")
	_connection_manager.create_server(port)


func _on_request_disconnect():
	Log.info("Server received request to disconnect")
	_connection_manager.disconnect_from_server()

