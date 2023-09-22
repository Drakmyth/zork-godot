extends Control

var message: String : get = _get_message, set = _set_message

signal confirmation_received

func _ready() -> void:
	$Cover/DialogAlignment/Background/Margin/DialogLayout/ButtonLayout/YesButton.connect("pressed", _on_YesButton_pressed)
	$Cover/DialogAlignment/Background/Margin/DialogLayout/ButtonLayout/NoButton.connect("pressed", _on_NoButton_pressed)

func _get_message() -> String:
	return $Cover/DialogAlignment/Background/Margin/DialogLayout/DialogMessage.text

func _set_message(message: String) -> void:
	$Cover/DialogAlignment/Background/Margin/DialogLayout/DialogMessage.text = message

func focus() -> void:
	$Cover/DialogAlignment/Background/Margin/DialogLayout/ButtonLayout/NoButton.grab_focus()

func _on_YesButton_pressed():
	confirmation_received.emit(true)

func _on_NoButton_pressed():
	confirmation_received.emit(false)
