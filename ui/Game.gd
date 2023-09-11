extends Control

var player: Player
@onready var history = $Margin/Layout/ResponseHistory

const EMPTY_PROMPT = " "
const HIDE_PROMPT = ""

const BEGIN_TEXT = "\
ZORK I: The Great Underground Empire
Copyright (c) 1981, 1982, 1983 Infocom, Inc. All rights reserved.
ZORK is a registered trademark of Infocom, Inc.
Revision 88 / Serial number 840726
"

func _ready() -> void:
	$Margin/Layout/Prompt.connect("command_submitted", _on_Prompt_command_submitted)

	player = get_tree().get_first_node_in_group("Player") as Player
	history.add_response(HIDE_PROMPT, BEGIN_TEXT)
	history.add_response(HIDE_PROMPT, player.get_room().describe())

func _on_Prompt_command_submitted(new_text: String) -> void:
	# No input, no command
	if new_text.is_empty():
		history.add_response(EMPTY_PROMPT, "I beg your pardon?")
		return

	var commands = $CommandParser.parse_input(new_text.to_lower(), player)

	var display_input = new_text
	for command in commands:
		print("Command: %s\n" % command.as_string())
		if not command.error_response.is_empty():
			history.add_response(display_input, command.error_response)
			break

		var request_chain = [
			player.action,
			player.get_room().on_begin_command,
			command.preaction
		]

		request_chain.append_array(command.indirect_objects.map(func(i): return i.action))
		if command.verb != "walk":
			# container.action
			request_chain.append_array(command.direct_objects.map(func(d): return d.action))

		request_chain.append(command.action)

		var response := ""
		for action in request_chain:
			response = action.call(command, player)
			if not response.is_empty():
				break

		player.get_room().on_end_command(command, player)

		history.add_response(display_input, response)
		display_input = ""
