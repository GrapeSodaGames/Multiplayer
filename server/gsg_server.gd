class_name GSGServer
extends Node

enum ServerStatus {
	DISCONNECTED,
	HOST,
	GUEST
}

signal connection_success
signal connection_failed
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

# Properties
const server_port = 25555
const max_players = 4

var ip: String

var players = {}
var player_info = {
	"player_number": 1,
	"color": "000000",
	"is_ready": false
}

## Private Variables
var server_status: ServerStatus = ServerStatus.DISCONNECTED


func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	multiplayer.multiplayer_peer = null
	Log.info("Server Ready")


func connect_to_server(new_ip, port):
	Log.info("Connecting to server at ", new_ip)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(new_ip, port)
	if error == ERR_CANT_CREATE:
		Log.warn("Could not connect to server at ", str(new_ip) + ":" + str(port))
		connection_failed.emit()
		return
	else:
		multiplayer.multiplayer_peer = peer
		server_status = ServerStatus.GUEST
		Log.info("Successfully connected to server")
		ip = new_ip
		connection_success.emit()
		send_player_info.rpc_id(1, multiplayer.get_unique_id(), player_info)
	
	
func create_server():
	Log.info("Creating server as host")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(server_port, max_players)
	if error:
		UI.debug_log.write("Encountered Error: " + str(error))
		return error
	else:
		multiplayer.multiplayer_peer = peer
		server_status = ServerStatus.HOST
		ip = "localhost"
		connection_success.emit()
		send_player_info.rpc_id(1, multiplayer.get_unique_id(), player_info)
	
	
func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	server_status = ServerStatus.DISCONNECTED
	players = {}


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
	register_player(id,info)
	update_player(id,info)
	
	
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

func get_server_ip() -> String:
	return ip

func get_ready_status() -> bool:
	var result = false
	for player in players.values():
		result = player.is_ready
	return result
	
func is_host() -> bool:
	return multiplayer.is_server()

## Events
func _on_peer_connected(_id):
	pass


func _on_peer_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	UI.set_ui_state(GSGUI.UIState.MainMenu)


func _on_connected_to_server():
	send_player_info.rpc_id(1, multiplayer.get_unique_id(), player_info)


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

