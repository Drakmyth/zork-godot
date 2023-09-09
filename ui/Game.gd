extends Control

func _ready() -> void:
	$Margin/Layout/Prompt.connect("command_submitted", _on_Prompt_command_submitted)

func _on_Prompt_command_submitted(new_text: String) -> void:
	var commands = $CommandParser.parse_input(new_text)
	for command in commands:
		print("Command: %s" % command.as_string())
