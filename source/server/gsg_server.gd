class_name GSGServer extends Node

signal connection_success
signal connection_failed
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected
signal player_updated(peer_id, player_info)


enum ServerStatus { DISCONNECTED, HOST, GUEST }

# Properties
const SERVER_PORT = 25555
const MAX_PLAYERS = 4

var players = PlayerList.new()

## Private Variables
var _ip: String
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
	


func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	_server_status = ServerStatus.DISCONNECTED
	players = PlayerList.new()


func get_server_ip() -> String:
	Log.dbg("Server ip is ", _ip)
	return _ip


func is_host() -> bool:
	return multiplayer.is_server()

func is_peer_connected() -> bool:
	return multiplayer.multiplayer_peer != null


@rpc("any_peer", "call_local")
func send_player_info(id, info):
	if multiplayer.is_server():
		var info_deserialized = PlayerInfo.deserialize(info)
		players.register_player(id, info_deserialized)
		for player_id in players.all():
			var player = players.by_id(player_id)
			update_player_info.rpc(player_id, player)


@rpc("call_local")
func update_player_info(id, info):
	players.update_player(id, info)
	player_updated.emit(id, info)



## Events
func _on_peer_connected(_id):
	pass


func _on_peer_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	UI.set_ui_state(GSGUI.UIState.MAIN_MENU)


func _on_connected_to_server():
	pass
	#send_player_info.rpc_id(1, multiplayer.get_unique_id(), _player_info)


func _on_connection_failed():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()


func _on_main_menu_request_connect_to_server(ip, port):
	connect_to_server(ip, port)


func _on_main_menu_request_create_new_server():
	create_server()


func _on_main_menu_request_disconnect():
	disconnect_from_server()
