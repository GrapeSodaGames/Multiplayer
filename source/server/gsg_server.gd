class_name GSGServer extends Node

signal connection_success
signal connection_failed
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

enum ServerStatus { DISCONNECTED, HOST, GUEST }

# Properties
const SERVER_PORT = 25555
const MAX_PLAYERS = 4

## Private Variables
var _ip: String
var _players = {}
var _player_info = {"player_number": 1, "color": "000000", "is_ready": false}
var _server_status: ServerStatus = ServerStatus.DISCONNECTED


func _ready():
	Log.dbg("Server Readying...")
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	multiplayer.multiplayer_peer = null
	Log.dbg("Server Ready")


# TODO: Code Smell - Long Method
func connect_to_server(new_ip, port):
	Log.info("Connecting to server at ", new_ip)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(new_ip, port)
	if error == ERR_CANT_CREATE:
		Log.warn("Could not connect to server at ", str(new_ip) + ":" + str(port))
		connection_failed.emit()
		return
	multiplayer.multiplayer_peer = peer
	_server_status = ServerStatus.GUEST
	Log.info("Successfully connected to server")
	_ip = new_ip
	connection_success.emit()
	send_player_info.rpc_id(1, multiplayer.get_unique_id(), _player_info)


# TODO: Code Smell - Long Method
func create_server():
	Log.info("Creating server as host")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	if error:
		UI.debug_log.write("Encountered Error: " + str(error))
		return error
	multiplayer.multiplayer_peer = peer
	_server_status = ServerStatus.HOST
	_ip = "localhost"
	connection_success.emit()
	send_player_info.rpc_id(1, multiplayer.get_unique_id(), _player_info)


func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	_server_status = ServerStatus.DISCONNECTED
	_players = {}


@rpc("any_peer", "call_local")
func send_player_info(id, info):
	if multiplayer.is_server():
		register_player(id, info)
		update_player(id, info)
		for player_id in _players:
			var player = _players[player_id]
			update_player_info.rpc(player_id, player)


@rpc("call_local")
func update_player_info(id, info):
	update_player(id, info)


func register_player(new_player_id, new_player_info):
	if not new_player_id in _players:
		new_player_info["player_number"] = _players.size() + 1
		if multiplayer.is_server():
			new_player_info["color"] = Color(randf(), randf(), randf()).to_html()
			new_player_info["is_ready"] = false
		_players[new_player_id] = new_player_info
		_player_info = new_player_info


func update_player(id, new_player_info):
	_players[id] = new_player_info
	_player_info = new_player_info


func get_server_ip() -> String:
	Log.dbg("Server ip is ", _ip)
	return _ip


func get_ready_status() -> bool:
	var result = false
	for player in _players.values():
		result = player.is_ready
	return result


func is_host() -> bool:
	return multiplayer.is_server()


func get_players() -> Dictionary:
	return _players


func set_player_ready(value: bool):
	var id = multiplayer.get_unique_id()
	_players[id].is_ready = value
	send_player_info.rpc_id(1, id, Server.get_player(id))


func set_player_color(color: Color):
	var id = multiplayer.get_unique_id()
	_players[id].color = color.to_html()
	send_player_info.rpc_id(1, id, _players[id])


func get_player(id: int) -> Dictionary:
	return _players[id]


func is_peer_connected() -> bool:
	return multiplayer.multiplayer_peer != null


## Events
func _on_peer_connected(_id):
	pass


func _on_peer_disconnected(id):
	_players.erase(id)
	player_disconnected.emit(id)
	UI.set_ui_state(GSGUI.UIState.MAIN_MENU)


func _on_connected_to_server():
	send_player_info.rpc_id(1, multiplayer.get_unique_id(), _player_info)


func _on_connection_failed():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	_players.clear()
	server_disconnected.emit()


func _on_main_menu_request_connect_to_server(ip, port):
	connect_to_server(ip, port)


func _on_main_menu_request_create_new_server():
	create_server()


func _on_main_menu_request_disconnect():
	disconnect_from_server()
