extends Label
class_name DebugLog

@onready var text_edit = get_node("TextEdit")

func _ready():
	write("Log Active")

func write(message):
	text_edit.text += message + "\n"
