class_name Credits extends UIScreen
## TODO: Document

# Signals

# Enums

# Exports

# References

# Properties

# Game Loop

# Public Methods


func setup():
	super.setup()


func enable(value: bool):
	super.enable(value)


# Private Methods


# Events
func _on_button_pressed():
	change_screen.emit("Main Menu")
