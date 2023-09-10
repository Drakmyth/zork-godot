extends Control

var player: Player

func _ready() -> void:
	$Margin/Layout/Prompt.connect("command_submitted", _on_Prompt_command_submitted)

	player = get_tree().get_first_node_in_group("Player") as Player
	print(player.get_room().describe())

func _on_Prompt_command_submitted(new_text: String) -> void:
	var commands = $CommandParser.parse_input(new_text, player)
	for command in commands:
		print("Command: %s\n" % command.as_string())
		var real_command = Vocabulary.get_command(command.verb)

		var request_chain = [
			# player.action,
			player.get_room().on_begin_command,
			real_command.preaction,
			# indirect.action,
			# if not walk, container.action
			# if not walk, direct.action # M-LOOK, M-ENTER happen as part of verb handling
			real_command.action,
			player.get_room().on_end_command
		]

		var response := ""
		for action in request_chain:
			response = action.call()
			if response != "":
				break

		$Margin/Layout/ResponseHistory.add_response(new_text, response)
