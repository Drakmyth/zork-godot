@tool
extends VBoxContainer

@export var input: String : set = _set_input
@export_multiline var response: String : set = _set_response

func _set_input(input_text: String):
	input = input_text
	$Layout/Prompt.text = input_text

func _set_response(response_text: String):
	response = response_text
	$ResponseText.text = response_text
