class_name UIScreen extends Control
## TODO: Document

# Signals
signal change_screen(screen: String)

# Enums

# Exports

# References
@onready var ui: GSGUI = get_node("/root/Main/UI")

# Properties

# Game Loop

# Public Methods


func setup():
	pass


func refresh():
	pass


func enable(value: bool):
	visible = value
	set_process(value)

# Private Methods

# Events
