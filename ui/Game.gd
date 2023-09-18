extends Control

var player: Player
@onready var history = $Margin/Layout/ResponseHistory
@onready var header = $Margin/Layout/Header

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

	player = get_tree().get_first_node_in_group(Vocabulary.Groups.PLAYER) as Player
	header.set_room_name(player.get_room().title)
	player.connect("room_changed", _on_Player_room_changed)

	history.add_response(HIDE_PROMPT, BEGIN_TEXT)
	history.add_response(HIDE_PROMPT, player.get_room().describe())
	player.get_room().flags |= Room.FLAG_VISITED

func _on_Prompt_command_submitted(new_text: String) -> void:
	# No input, no command
	if new_text.is_empty():
		history.add_response(EMPTY_PROMPT, "I beg your pardon?")
		return

	var commands = $CommandParser.parse_input(new_text.to_lower(), player)

	var display_input = new_text
	for command in commands:
		print("Command: %s\n" % command.as_string())

		# Error occurred during parsing and/or matching
		if not command.error_response.is_empty():
			history.add_response(display_input, command.error_response)
			break

		var object_commands = command.split_object_commands()
		var responses = []
		for obj_command in object_commands:
			var response = _execute_command(obj_command)
			responses.append(response)
		history.add_response(display_input, "\n".join(responses))
		display_input = ""


func _execute_command(command: Command):
	var response = []
	var taken_response = command.try_take(player)
	if taken_response == "(Taken)":
		response.append(taken_response)

	var request_chain = command.get_request_chain(player)

	var action_response := ""
	for action in request_chain:
		action_response = action.call(command, player)
		if not action_response.is_empty():
			response.append(action_response)
			break

	response.append(player.get_room().on_end_command(command, player))
	response = response.filter(func(r): return not r.is_empty())
	if not response.is_empty():
		response[0] = "%s%s" % [command.prefix, response[0]]
	return "\n".join(response)

func _on_Player_room_changed(room: Room):
	header.set_room_name(room.title)
