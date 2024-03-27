class_name MainMenu
extends Control

## TODO: Document

## Signals
signal changed
signal request_connect_to_server(ip, port)
signal request_create_new_server
signal request_disconnect

## References
@onready var server = get_tree().root.get_node("Main/Server")
@onready var host_button: Button = get_node("%Host Button")
@onready var connect_button = get_node("%Connect Button")
@onready var disconnect_button = get_node("%Disconnect Button")
@onready var connect_server_ip_textbox = get_node("%Connect Server IP")

## Game Loop
func _enter_tree():
	changed.connect(_on_changed)

func _ready():
	changed.emit()

func _process(delta):
	pass

## Events
func _on_connect_server_ip_text_changed():
	changed.emit()

func _on_changed():
	check_connection_status_for_buttons()
	
func _on_host_button_pressed():
	request_create_new_server.emit()
	changed.emit()

func _on_connect_button_pressed():
	var server_ip = connect_server_ip_textbox.text
	var server_port = 25555
	request_connect_to_server.emit(server_ip, server_port)
	changed.emit()

func _on_disconnect_button_pressed():
	request_disconnect.emit()
	changed.emit()

# Methods
func check_connection_status_for_buttons():
	handle_host_button()
	handle_connect_button()
	
	if not server.is_connected_to_server(): 
		disconnect_button.disabled = true
	else:
		disconnect_button.disabled = false

func handle_host_button():
	if not server.is_connected_to_server():
		host_button.disabled = false
		host_button.text = "Host Server"
	else:
		host_button.disabled = true
		if server.is_server_host():
			host_button.text = "Server Running"
		else:
			host_button.text = "Connected as Guest"

func handle_connect_button():
	if not server.is_connected_to_server():
		connect_button.disabled = false
		connect_button.text = "Connect to Server"
	else:
		connect_button.disabled = true
		if not server.is_server_host():
			connect_button.text = "Connected"
		else:
			connect_button.text = "Connected as Host"