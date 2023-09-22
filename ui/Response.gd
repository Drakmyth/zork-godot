@tool
extends VBoxContainer

@export var input: String : set = _set_input
@export_multiline var response: String : set = _set_response

func _ready() -> void:
	$Layout.visible = not $Layout/Prompt.text.is_empty()

func _set_input(_input: String):
	input = _input
	$Layout/Prompt.text = input
	$Layout.visible = not input.is_empty()

func _set_response(_response: String):
	response = _response
	$ResponseText.text = response
