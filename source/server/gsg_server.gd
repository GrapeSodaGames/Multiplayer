class_name GSGServer extends Node

signal connection_success
signal connection_failed
signal server_disconnected
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)

enum ServerStatus { DISCONNECTED, HOST, GUEST }

## Properties
var players = {}
var player_info = {"player_number": 1, "color": "000000", "is_ready": false}

## Private Variables
var _server_status: ServerStatus = ServerStatus.DISCONNECTED

## Components
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

## Methods
@rpc("any_peer", "call_local")
func send_player_info(id, info):
	if multiplayer.is_server():
		register_player(id, info)
		update_player(id, info)
		for player_id in players:
			var player = players[player_id]
			update_player_info.rpc(player_id, player)


@rpc("call_local")
func update_player_info(id, info):
	update_player(id, info)


func register_player(new_player_id, new_player_info):
	if not new_player_id in players:
		new_player_info["player_number"] = players.size() + 1
		if multiplayer.is_server():
			new_player_info["color"] = Color(randf(), randf(), randf()).to_html()
			new_player_info["is_ready"] = false
		players[new_player_id] = new_player_info
		player_info = new_player_info


func update_player(id, new_player_info):
	players[id] = new_player_info
	player_info = new_player_info


func get_ready_status() -> bool:
	var result = false
	for player in players.values():
		result = player.is_ready
	return result


func is_host() -> bool:
	return multiplayer.is_server()


func get_players() -> Dictionary:
	return players


func set_player_ready(value: bool):
	var id = multiplayer.get_unique_id()
	players[id].is_ready = value
	send_player_info.rpc_id(1, id, Server.get_player(id))


func set_player_color(color: Color):
	var id = multiplayer.get_unique_id()
	players[id].color = color.to_html()
	send_player_info.rpc_id(1, id, players[id])


func get_player(id: int) -> Dictionary:
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
