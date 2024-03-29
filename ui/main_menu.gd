class_name MainMenu
extends Control

## TODO: Document

## Signals
signal request_connect_to_server(ip, port)
signal request_create_new_server

## References
@onready var server: GSGServer = get_tree().root.get_node("Main/Server")
@onready var host_button: Button = get_node("%Host Button")
@onready var connect_button = get_node("%Connect Button")
@onready var connect_server_ip_textbox = get_node("%Connect Server IP")

## Game Loop
func _enter_tree():
	pass

func _ready():
	pass

func _process(delta):
	check_connection_status_for_buttons()

## Events
func _on_host_button_pressed():
	request_create_new_server.emit()

func _on_connect_button_pressed():
	var server_ip = connect_server_ip_textbox.text
	var server_port = 25555
	request_connect_to_server.emit(server_ip, server_port)

# Methods
func check_connection_status_for_buttons():
	handle_host_button()
	handle_connect_button()
	
	
func handle_host_button():
	print(multiplayer.multiplayer_peer)
	if multiplayer.multiplayer_peer == null:
		host_button.disabled = false
		host_button.text = "Host Server"
	else:
		host_button.disabled = true
		if multiplayer.is_server():
			host_button.text = "Server Running"
		else:
			host_button.text = "Connected as Guest"

func handle_connect_button():
	if multiplayer.multiplayer_peer == null:
		connect_button.disabled = false
		connect_button.text = "Connect to Server"
	else:
		connect_button.disabled = true
		if not multiplayer.is_server():
			connect_button.text = "Connected"
		else:
			connect_button.text = "Connected as Host"
