extends VBoxContainer
class_name DebugLog

@onready var text_edit: TextEdit = get_node("TextEdit")

func _ready():
	write("Log Active")


func write(message):
	text_edit.text += message + "\n"


func _on_button_toggled(toggled_on):
	text_edit.visible = toggled_on
