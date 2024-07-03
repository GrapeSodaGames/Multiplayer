class_name DebugLog extends VBoxContainer
## TODO: Document

# Signals

# Enums

# Exports

# References
@onready var text_label: RichTextLabel = get_node("%RichTextLabel")

# Properties


# Game Loop
func _ready():
	Log.dbg("DebugLog Readying...")
	Log.log_message.connect(_on_log_message)
	Log.dbg("Log connected to in game debug log")
	Log.dbg("DebugLog Ready")


# Public Methods

# Private Methods


# Events
func _on_log_message(_log_level, message):
	text_label.text += message + "\n"


func _on_button_toggled(toggled_on):
	text_label.visible = toggled_on
