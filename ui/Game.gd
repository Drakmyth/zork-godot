extends Control

func _ready() -> void:
	$Margin/Layout/Prompt.connect("command_submitted", _on_Prompt_command_submitted)

func _on_Prompt_command_submitted(new_text: String) -> void:
	$CommandParser.parse_command(new_text)
