class_name MainMenu extends UIScreen

## TODO: Document

## Signals
signal request_connect_to_server(ip, port)
signal request_create_new_server

## References
@onready var host_button: Button = get_node("%Host Button")
@onready var connect_button: Button = get_node("%Connect Button")
@onready var connect_server_ip_textbox: LineEdit = get_node("%Connect Server IP")
@onready var game: GSGGame = get_node("/root/Game")


## Game Loop
func _ready():
	connect_server_ip_textbox.text = game.get_config_server_ip()


func _process(_delta):
	check_connection_status_for_buttons()


## Events
func _on_host_button_pressed():
	request_create_new_server.emit()


func _on_connect_button_pressed():
	var server_ip = connect_server_ip_textbox.text
	var server_port = 25555  # TODO: Code Smell - Magic Number
	request_connect_to_server.emit(server_ip, server_port)


# Methods
func setup():
	super.setup()


func enable(value: bool):
	super.enable(value)


func check_connection_status_for_buttons():
	handle_host_button()
	handle_connect_button()


func handle_host_button():
	if not Server.is_peer_connected():
		host_button.disabled = false
		host_button.text = "Host Server"
	else:
		host_button.disabled = true
		if multiplayer.is_server():
			host_button.text = "Server Running"
		else:
			host_button.text = "Connected as Guest"


# TODO: Code Smell - duplicate code
func handle_connect_button():
	if not Server.is_peer_connected():
		connect_button.disabled = false
		connect_button.text = "Connect to Server"
	else:
		connect_button.disabled = true
		if not multiplayer.is_server():
			connect_button.text = "Connected"
		else:
			connect_button.text = "Connected as Host"


func clear_ip_text():
	connect_server_ip_textbox.text = ""
