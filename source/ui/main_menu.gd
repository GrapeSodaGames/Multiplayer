class_name MainMenu extends UIScreen
## TODO: Document

# Signals

# Enums

# Exports

# References
@onready var host_button: Button = get_node("%Host Button")
@onready var connect_button: Button = get_node("%Connect Button")
@onready var connect_server_ip_textbox: LineEdit = get_node("%Connect Server IP")
#@onready var game: GSGGame = get_node("/root/Game")

# Properties

# Game Loop
func _ready():
	GameState.connection_failed.connect(_on_connection_failed)
	GameState.connection_succeeded.connect(_on_connection_success)
#func _process(_delta):
#	_check_connection_status_for_buttons()

# Public Methods
func setup():
	super.setup()
#	connect_server_ip_textbox.text = game.local_config().get_config_server_ip()


func enable(value: bool):
	super.enable(value)


# Private Methods
func _check_connection_status_for_buttons():
	_handle_host_button()
	_handle_connect_button()


func _handle_host_button():
	if not GameState.is_peer_connected():
		host_button.disabled = false
		host_button.text = "Host Server"
	else:
		host_button.disabled = true
		if multiplayer.is_server():
			host_button.text = "Server Running"
		else:
			host_button.text = "Connected as Guest"


# TODO: Code Smell - duplicate code
func _handle_connect_button():
	if not GameState.is_peer_connected():
		connect_button.disabled = false
		connect_button.text = "Connect to Server"
	else:
		connect_button.disabled = true
		if not multiplayer.is_server():
			connect_button.text = "Connected"
		else:
			connect_button.text = "Connected as Host"


func _clear_ip_text():
	connect_server_ip_textbox.text = ""

# Events
func _on_host_button_pressed():
	var player_name = "Player1Name" #TODO: Fix this
	GameState.host_game(player_name)


func _on_connect_button_pressed():
	GameState.join_game(%"Connect Server IP".text, "Player2Name")


func _on_credit_button_pressed():
	Log.dbg("main_menu received credit button signal")
	ui.set_ui_state(GSGUI.UIState.CREDITS)

func _on_connection_success():
	ui.set_ui_state(GSGUI.UIState.LOBBY)


func _on_connection_failed():
	Log.info("UI received connection failed from server")
	#_main_menu.clear_ip_text()
