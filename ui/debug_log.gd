extends VBoxContainer
class_name DebugLog

@onready var text_edit: TextEdit = get_node("TextEdit")

var open = false

func _ready():
	write("Log Active")


func write(message):
	text_edit.text += message + "\n"


func _on_button_toggled(toggled_on):
	print(text_edit.size_flags_vertical)
	if toggled_on:
		text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	else:
		text_edit.size_flags_vertical = Control.SIZE_FILL
