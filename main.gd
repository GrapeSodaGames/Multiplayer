class_name Main
extends Node

@onready var game: GSGGame = get_node("Game")
@onready var server: GSGServer = get_node("Server")
@onready var ui: GSGUI = get_node("UI")

func _ready():
	ui.request_connect_to_server.connect(_on_request_connect_to_server)
	ui.request_create_new_server.connect(_on_request_create_new_server)
	ui.request_disconnect.connect(_on_request_disconnect)

func _on_debug_msg(msg: String):
	ui.debug_log.write(msg)

func _on_request_connect_to_server(ip, port):
	server.connect_to_server(ip, port)

func _on_request_create_new_server():
	server.create_server()

func _on_request_disconnect():
	server.disconnect_from_server()
