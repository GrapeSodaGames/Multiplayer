class_name GSGUI
extends Node

signal request_connect_to_server(ip, port)
signal request_create_new_server
signal request_disconnect

@onready var main_menu: MainMenu = get_node("Main Menu")
@onready var debug_log = get_node("Debug Log")

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu.request_connect_to_server.connect(_on_connect_request)
	main_menu.request_create_new_server.connect(_on_create_host_request)
	main_menu.request_disconnect.connect(_on_disconnect_request)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_connect_request(ip, port):
	request_connect_to_server.emit(ip, port)

func _on_create_host_request():
	request_create_new_server.emit(8)

func _on_disconnect_request():
	request_disconnect.emit()