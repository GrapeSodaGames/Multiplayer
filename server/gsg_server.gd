class_name GSGServer
extends Node

enum ServerStatus {
	DISCONNECTED,
	HOST,
	GUEST
}

signal connection_sucess
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

# Properties
const server_port = 25555
const default_server_ip = "localhost"
const max_players = 6

var players = {}
var player_info = {
	"player_number": 1,
	"color": "000000",
	"is_ready": false
}

## Private Variables
var server_status: ServerStatus = ServerStatus.DISCONNECTED
@onready var main :Main = get_tree().root.get_node("Main")

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func _process(delta):
	pass

func connect_to_server(ip, port):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, port)
	if error:
		main.ui.debug_log.write("Encountered Error: " + str(error))
		return error
	else:
		multiplayer.multiplayer_peer = peer
		server_status = ServerStatus.GUEST
		connection_sucess.emit()
		send_player_info(multiplayer.get_unique_id(), player_info)
	
func create_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(server_port, max_players)
	if error:
		main.ui.debug_log.write("Encountered Error: " + str(error))
		return error
	else:
		multiplayer.multiplayer_peer = peer
		server_status = ServerStatus.HOST
		connection_sucess.emit()
		send_player_info(multiplayer.get_unique_id(), player_info)
	
func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	server_status = ServerStatus.DISCONNECTED

func is_connected_to_server() -> bool:
	return not server_status == ServerStatus.DISCONNECTED

func is_server_host() -> bool:
	return server_status == ServerStatus.HOST

@rpc("any_peer")
func send_player_info(id, info):
	register_player(id, info)
	update_player(id, info)

	if multiplayer.is_server():
		for player_id in players:
			var player = players[player_id]
			send_player_info.rpc(player_id, player)

func register_player(new_player_id, new_player_info):
	if not new_player_id in players:
		new_player_info["player_number"] = players.size() + 1
		new_player_info["color"] = Color(randf(), randf(), randf()).to_html()
		players[new_player_id] = new_player_info
		player_info = new_player_info


func update_player(id, new_player_info):
	players[id] = new_player_info
	player_info = new_player_info

## Events
func _on_peer_connected(id):
	pass

func _on_peer_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

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

