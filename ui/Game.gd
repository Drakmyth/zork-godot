extends Control

var player: Player

func _ready() -> void:
	$Margin/Layout/Prompt.connect("command_submitted", _on_Prompt_command_submitted)

	player = get_tree().get_first_node_in_group("Player") as Player
	print(player.get_room().description)

func _on_Prompt_command_submitted(new_text: String) -> void:
	var commands = $CommandParser.parse_input(new_text)
	for command in commands:
		print("Command: %s\n" % command.as_string())
		var real_command = Vocabulary.get_command(command.verb)
		real_command.preaction()
		real_command.action()
		print("\n")
