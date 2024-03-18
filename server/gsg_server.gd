class_name GSGServer
extends Node

enum ServerStatus {
	DISCONNECTED,
	HOST,
	GUEST
}

signal debug(String)


# Properties
const server_port = 25555

## Private Variables
var server_status: ServerStatus = ServerStatus.DISCONNECTED

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func _process(delta):
	pass


func connect_to_server(ip, port):
	debug.emit("Attempting to connect to server at " + str(ip) + ":" + str(port))
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	server_status = ServerStatus.GUEST
	
func create_server(max_players):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(server_port, max_players)
	multiplayer.multiplayer_peer = peer
	server_status = ServerStatus.HOST
	debug.emit("creating new server on port " + str(server_port) + " with max players = " + str(max_players))

func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	server_status = ServerStatus.DISCONNECTED
	debug.emit("disconnecting from server ")

func is_connected_to_server() -> bool:
	return not server_status == ServerStatus.DISCONNECTED

func is_server_host() -> bool:
	return server_status == ServerStatus.HOST

## Events
func _on_peer_connected(id):
	if multiplayer.is_server():
		debug.emit(str(id) + "connected")

func _on_peer_disconnected(id):
	if multiplayer.is_server():
		debug.emit(str(id) + "disconnected")

func _on_main_menu_request_connect_to_server(ip, port):
	connect_to_server(ip, port)

func _on_main_menu_request_create_new_server():
	create_server(8)

func _on_main_menu_request_disconnect():
	disconnect_from_server()

func _on_connected_to_server():
	debug.emit("Connected successfully to server with id " + str(multiplayer.get_unique_id()))

func _on_connection_failed():
	debug.emit("Server connection failed")

func _on_server_disconnected():
	debug.emit("Server has disconnected")