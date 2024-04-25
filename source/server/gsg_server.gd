class_name GSGServer extends Node

signal connection_success
signal connection_failed
signal server_disconnected
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)

enum ServerStatus { DISCONNECTED, HOST, GUEST }

## Properties
var player_info = PlayerInfo.new()

## Components
var connection_manager: ConnectionMananger
var players: PlayerList = PlayerList.new()


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
	add_child(players)
	

func _process(delta):
	if is_peer_connected() and multiplayer.is_server():
		broadcast_all_players.rpc_id(1)

## Methods
@rpc("any_peer", "call_local")
func send_player_info(id, info: Dictionary):
	if multiplayer.is_server():
		var new_player_info: PlayerInfo = PlayerInfo.deserialize(info)
		players.register_player(id, new_player_info)
		broadcast_all_players()

@rpc("call_local")
func broadcast_all_players():
	for player_id in players.all():
		var player = players.get_by_id(player_id)
		update_player_info.rpc(player.serialize())

@rpc("call_local")
func update_player_info(info: Dictionary):
	var new_player_info: PlayerInfo = PlayerInfo.deserialize(info)
	players.update(new_player_info)
	player_info = new_player_info


func get_ready_status() -> bool:
	var result = false
	for player in players.all().values():
		result = player.is_ready()
	return result


func is_host() -> bool:
	return multiplayer.is_server()


func get_players() -> PlayerList:
	if not players is PlayerList:
		return PlayerList.new()
	return players

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
