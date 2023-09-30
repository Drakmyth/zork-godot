extends Control

var message: String : get = _get_message, set = _set_message

@onready var yes_button = $Cover/DialogAlignment/Background/Margin/DialogLayout/ButtonLayout/YesButton
@onready var no_button = $Cover/DialogAlignment/Background/Margin/DialogLayout/ButtonLayout/NoButton
@onready var quit_button = $Cover/DialogAlignment/Background/Margin/DialogLayout/ButtonLayout/QuitButton
@onready var dialog_message = $Cover/DialogAlignment/Background/Margin/DialogLayout/DialogMessage

signal confirmation_received

func _ready() -> void:
	yes_button.connect("pressed", _on_YesButton_pressed)
	no_button.connect("pressed", _on_NoButton_pressed)
	quit_button.connect("pressed", _on_QuitButton_pressed)

func _get_message() -> String:
	return dialog_message.text

func _set_message(_message: String) -> void:
	dialog_message.text = _message

func focus() -> void:
	if quit_button.visible:
		quit_button.grab_focus()
	else:
		no_button.grab_focus()

func set_choice_mode(choice: bool) -> void:
	yes_button.visible = choice
	no_button.visible = choice
	quit_button.visible = not choice

func _on_YesButton_pressed():
	confirmation_received.emit(true)

func _on_NoButton_pressed():
	confirmation_received.emit(false)

func _on_QuitButton_pressed():
	get_tree().quit()
	confirmation_received.emit(true)
