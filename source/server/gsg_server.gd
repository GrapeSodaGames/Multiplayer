class_name GSGServer extends Node
## TODO: Document

# Signals
signal connection_success
signal connection_failed
signal server_disconnected
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)


# Enums
enum ServerStatus { DISCONNECTED, HOST, GUEST }

# Exports

# References
var _players = PlayerList.new()

# Properties
var _connection_manager: ConnectionMananger
var _timer: Timer
@onready var _game: GSGGame = get_node("/root/Game")


# Game Loop
func _init():
	Log.dbg("Server Initializing...")
	_connection_manager = ConnectionMananger.new()
	add_child(_connection_manager)
	
	_timer = Timer.new()
	_timer.wait_time = 0.05
	_timer.autostart = true
	add_child(_timer)
	
	Log.dbg("Server Initialized")


func _ready():
	_timer.timeout.connect(_on_timer_timeout)
	
	UI.request_create_new_server_signal.connect(_on_request_create_new_server)
	UI.request_connect_to_server_signal.connect(_on_request_connect)
	UI.request_disconnect_from_server_signal.connect(_on_request_disconnect)

	_timer.start()


# Public Methods
func sync_local_players():
	if not is_peer_connected():
		return
	if _game.player_info():
		Log.dbg("Sending Player Info To Server: ", _game.player_info().serialize())
		_send_player_info.rpc_id(1, multiplayer.get_unique_id(), _game.player_info().serialize())

	if is_host():
		for player in _players.all():
			_update_player_info.rpc(player.serialize())
			
	_game.sync_player_from_server()


func get_players() -> PlayerList:
	return _players


func get_player(id: int) -> PlayerInfo:
	return _players.by_id(id)


func get_local_player() -> PlayerInfo:
	for player: PlayerInfo in get_players().all():
		if player.is_local_player():
			return player
	return
	
func is_peer_connected() -> bool:
	if _connection_manager:
		return _connection_manager.is_peer_connected()
	return false


func is_host() -> bool:
	if is_peer_connected():
		return multiplayer.is_server()
	return false


func connection_manager() -> ConnectionMananger:
	return _connection_manager


# Private Methods
@rpc("any_peer", "call_local")
func _send_player_info(id: int, info: Dictionary):
	if not is_host():
		return
	Log.dbg("Server Received Player Info from ", id)
	if not is_peer_connected(): 
		return
	
	var new_player_info = PlayerInfo.deserialize(info)
	_register_player(id, new_player_info)
	_players.update(new_player_info)
	Log.dbg("send_player_info received ", new_player_info.serialize())


@rpc("any_peer", "call_local")
func _update_player_info(info: Dictionary):
	Log.dbg("Received player info from Server: ", info)
	_players.update(PlayerInfo.deserialize(info))


func _register_player(new_player_id: int, new_player_info: PlayerInfo):
	if multiplayer.is_server():
		var info = new_player_info.clone()
		info.set_id(new_player_id)
		var existing_player: PlayerInfo = _players.by_id(new_player_id)
		if not existing_player:
			Log.info("Registering new player ", new_player_id)
			info.set_number(_players.size() + 1)
			info.set_color(Color(randf(), randf(), randf()))
			info.set_ready(false)
			_players.update(info)


# Events
func _on_request_connect(ip, port):
	Log.info("Server received request to connect to server")
	_connection_manager.connect_to_server(ip, port)


func _on_request_create_new_server(port):
	Log.info("Server received request to create a server")
	_connection_manager.create_server(port)


func _on_request_disconnect():
	Log.info("Server received request to disconnect")
	_connection_manager.disconnect_from_server()


func _on_timer_timeout():
	sync_local_players()
