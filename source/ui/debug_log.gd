class_name DebugLog extends VBoxContainer

@onready var text_edit: TextEdit = get_node("TextEdit")


func _ready():
	Log.log_message.connect(_on_log_message)


func _on_log_message(_log_level, message):
	text_edit.text += message + "\n"


func _on_button_toggled(toggled_on):
	text_edit.visible = toggled_on
