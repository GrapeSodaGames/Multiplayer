extends Node

enum ServerStatus {
	DISCONNECTED,
	HOST,
	GUEST
}

## Design Handles
@export var server_port = 25555 

## Private Variables
var server_status: ServerStatus = ServerStatus.DISCONNECTED

## References
@onready var main_menu = get_node("Main Menu")
@onready var debug_log: DebugLog = get_node("Debug Log")

## Game Loop and Events
func _init():
	pass
func _enter_tree():
	pass
func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _process(delta):
	pass

## Events
func _on_peer_connected(id):
	if multiplayer.is_server():
		debug_log.write(str(id) + "connected")

func _on_peer_disconnected(id):
	if multiplayer.is_server():
		debug_log.write(str(id) + "disconnected")

func _on_main_menu_request_connect_to_server(ip, port):
	connect_to_server(ip, port)

func _on_main_menu_request_create_new_server():
	create_server(8)

func _on_main_menu_request_disconnect():
	disconnect_from_server()

func _on_connected_to_server():
	debug_log.write("Connected successfully to server with id " + str(multiplayer.get_unique_id()))

func _on_connection_failed():
	debug_log.write("Server connection failed")

func _on_server_disconnected():
	debug_log.write("Server has disconnected")

## Methods
func connect_to_server(ip, port):
	debug_log.write("Attempting to connect to server at " + str(ip) + ":" + str(port))
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	server_status = ServerStatus.GUEST
	
func create_server(max_players):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(server_port, max_players)
	multiplayer.multiplayer_peer = peer
	server_status = ServerStatus.HOST
	debug_log.write("creating new server on port " + str(server_port) + " with max players = " + str(max_players))

func disconnect_from_server():
	multiplayer.multiplayer_peer = null
	server_status = ServerStatus.DISCONNECTED
	debug_log.write("disconnecting from server ")

func is_connected_to_server() -> bool:
	return not server_status == ServerStatus.DISCONNECTED

func is_server_host() -> bool:
	return server_status == ServerStatus.HOST