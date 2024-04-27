class_name GSGServer extends Node

signal connection_success
signal connection_failed
signal server_disconnected
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)

enum ServerStatus { DISCONNECTED, HOST, GUEST }
## Private Variables
var players = PlayerList.new()

## Properties
@onready var game: GSGGame = get_node("/root/Game")
@onready var connection_manager: ConnectionMananger


## Game Loop
func _init():
	Log.info("Server Initializing...")
	connection_manager = ConnectionMananger.new()
	add_child(connection_manager)
	Log.info("Server Initialized")


func _ready():
	UI.request_create_new_server_signal.connect(_on_request_create_new_server)
	UI.request_connect_to_server_signal.connect(_on_request_connect)
	UI.request_disconnect_from_server_signal.connect(_on_request_disconnect)


func _process(_delta):
	if is_peer_connected():
		send_player_info.rpc_id(1, multiplayer.get_unique_id(), game.player_info().serialize())

		for player in players.all():
			update_player_info.rpc(player.serialize())


## Methods
@rpc("any_peer", "call_local")
func send_player_info(id: int, info: Dictionary):
	if not is_peer_connected():
		return
	if not multiplayer.is_server():
		return

	if players.by_id(id) is PlayerInfo:
		update_player_info.rpc(players.by_id(id).serialize())
	else:
		var new_player_info = PlayerInfo.deserialize(info)
		register_player(id, new_player_info)
		Log.info("send_player_info received ", new_player_info.serialize())


@rpc("call_local")
func update_player_info(info: Dictionary):
	players.update(PlayerInfo.deserialize(info))


func register_player(new_player_id: int, new_player_info: PlayerInfo):
	if multiplayer.is_server():
		var info = new_player_info.clone()
		info.set_id(new_player_id)
		if not new_player_id in players.all():
			info.set_number(players.size() + 1)
			if multiplayer.is_server():
				info.set_color(Color(randf(), randf(), randf()))
				info.set_ready(false)
			players.update(info)


func is_host() -> bool:
	return multiplayer.is_server()


func get_players() -> PlayerList:
	return players


func get_player(id: int) -> PlayerInfo:
	return players.by_id(id)


func is_peer_connected() -> bool:
	if connection_manager:
		return connection_manager.is_peer_connected()
	return false


## Events
func _on_request_connect(ip, port):
	Log.info("Server received request to connect to server")
	connection_manager.connect_to_server(ip, port)


func _on_request_create_new_server(port):
	Log.info("Server received request to create a server")
	connection_manager.create_server(port)


func _on_request_disconnect():
	connection_manager.disconnect_from_server()
