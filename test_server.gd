class_name TestServer extends Node
## TODO: Document

# Signals

# Enums

# Exports

# Properties
const PORT: int = 4433
# References

# Game Loop
func _ready():
	get_tree().paused = true
	multiplayer.server_relay = false
	
	if DisplayServer.get_name() == "headless":
		Log.info("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()
		
func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server")
		return
	multiplayer.multiplayer_peer = peer
	

func _on_connect_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client")
		return
	multiplayer.multiplayer_peer = peer
	start_game()
func start_game():
	$UI.hide()
	get_tree().paused = false
# Public Methods

# Private Methods

# Events

