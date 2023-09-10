extends Control

func _ready() -> void:
	$Margin/Layout/Prompt.connect("command_submitted", _on_Prompt_command_submitted)

func _on_Prompt_command_submitted(new_text: String) -> void:
	var commands = $CommandParser.parse_input(new_text)
	for command in commands:
		print("Command: %s\n" % command.as_string())
		var real_command = Vocabulary.get_command(command.verb)
		real_command.preaction()
		real_command.action()
		print("\n")
