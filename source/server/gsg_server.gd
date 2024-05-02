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
var connection_manager: ConnectionMananger
var timer: Timer


## Game Loop
func _init():
	Log.info("Server Initializing...")
	connection_manager = ConnectionMananger.new()
	add_child(connection_manager)
	
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	add_child(timer)
	
	Log.info("Server Initialized")


func _ready():
	timer.timeout.connect(_on_timer_timeout)
	
	UI.request_create_new_server_signal.connect(_on_request_create_new_server)
	UI.request_connect_to_server_signal.connect(_on_request_connect)
	UI.request_disconnect_from_server_signal.connect(_on_request_disconnect)

	timer.start()


## Methods
@rpc("any_peer", "call_local")
func send_player_info(id: int, info: Dictionary):
	Log.dbg("Server Received Player Info from ", id)
	if not is_peer_connected(): 
		return
	
	var new_player_info = PlayerInfo.deserialize(info)
	register_player(id, new_player_info)
	players.update(new_player_info)
	Log.dbg("send_player_info received ", new_player_info.serialize())


@rpc("any_peer", "call_local")
func update_player_info(info: Dictionary):
	Log.dbg("Received player info from Server: ", info)
	players.update(PlayerInfo.deserialize(info))

func process_players():
	if not is_peer_connected():
		return
	
	Log.dbg("Sending Player Info To Server")
	send_player_info.rpc_id(1, multiplayer.get_unique_id(), game.player_info().serialize())

	if is_host():
		for player in players.all():
			update_player_info.rpc(player.serialize())

func register_player(new_player_id: int, new_player_info: PlayerInfo):
	if multiplayer.is_server():
		var info = new_player_info.clone()
		info.set_id(new_player_id)
		var existing_player: PlayerInfo = players.by_id(new_player_id)
		if not existing_player:
			Log.info("Registering new player ", new_player_id)
			info.set_number(players.size() + 1)
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
	Log.info("Server received request to disconnect")
	connection_manager.disconnect_from_server()


func _on_timer_timeout():
	process_players()
