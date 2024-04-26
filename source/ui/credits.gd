class_name Credits extends UIScreen


func setup():
	super.setup()


func enable(value: bool):
	super.enable(value)


func _on_button_pressed():
	UI.set_ui_state(GSGUI.UIState.MAIN_MENU)
