class_name Main
extends Node

@onready var game: GSGGame = get_node("Game")

func _ready():
	UI.request_disconnect.connect(_on_request_disconnect)

func _on_debug_msg(msg: String):
	UI.debug_log.write(msg)

func _on_request_disconnect():
	Server.disconnect_from_server()

