class_name GSGServer extends Node

signal connection_success
signal connection_failed
signal server_disconnected
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)

enum ServerStatus { DISCONNECTED, HOST, GUEST }

## Properties
var players = {}
var player_info = PlayerInfo.new()

## Components
var connection_manager: ConnectionMananger


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
	UI.request_set_player_ready.connect(_on_request_set_ready)

## Methods
@rpc("any_peer", "call_local")
func send_player_info(id, info: Dictionary):

	if multiplayer.is_server():
		var new_player_info: PlayerInfo = PlayerInfo.deserialize(info)
		register_player(id, new_player_info)
		update_player(id, new_player_info)
		for player_id in players:
			var player = players[player_id]
			update_player_info.rpc(player_id, player.serialize())


@rpc("call_local")
func update_player_info(id, info: Dictionary):
	update_player(id, PlayerInfo.deserialize(info))


func register_player(new_player_id, new_player_info: PlayerInfo):
	if not new_player_id in players:
		new_player_info.set_player_number(players.size() + 1)
		new_player_info.set_id(new_player_id)
		if multiplayer.is_server():
			new_player_info.set_color(Color(randf(), randf(), randf()))
			new_player_info.set_ready(false)
		players[new_player_id] = new_player_info
		player_info = new_player_info


func update_player(id, new_player_info: PlayerInfo):
	players[id] = new_player_info
	player_info = new_player_info


func get_ready_status() -> bool:
	var result = false
	for player in players.values():
		result = player.is_ready()
	return result


func is_host() -> bool:
	return multiplayer.is_server()


func get_players() -> Dictionary:
	return players


func set_player_ready(value: bool):
	var id = multiplayer.get_unique_id()
	players[id].set_ready(value)
	send_player_info.rpc_id(1, id, Server.get_player(id).serialize())


func set_player_color(color: Color):
	var id = multiplayer.get_unique_id()
	players[id].set_color(color)
	send_player_info.rpc_id(1, id, players[id].serialize())


func get_player(id: int) -> PlayerInfo:
	return players[id]


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

func _on_request_set_ready(value: bool):
	player_info.set_ready(value)
	send_player_info.rpc_id(1, multiplayer.get_unique_id(), player_info.serialize())
