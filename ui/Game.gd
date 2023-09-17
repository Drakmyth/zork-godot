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

func _on_Prompt_command_submitted(new_text: String) -> void:
	# No input, no command
	if new_text.is_empty():
		history.add_response(EMPTY_PROMPT, "I beg your pardon?")
		return

	var commands = $CommandParser.parse_input(new_text.to_lower(), player)

	var display_input = new_text
	for command in commands:
		print("Command: %s\n" % command.as_string())

		var response = []
		var taken_response = command.try_take(player)
		if ["", "(Taken)"].has(taken_response):
			response.append(taken_response)

		if not command.error_response.is_empty():
			response.append(command.error_response)
			response = response.filter(func(r): return not r.is_empty())
			history.add_response(display_input, "\n".join(response))
			break

		var request_chain = [
			command.check_holding,
			player.action,
			player.get_room().on_begin_command,
			command.preaction
		]

		request_chain.append_array(command.indirect_objects.map(func(i): return i.action))
		if command.verb != Vocabulary.Verbs.WALK:
			# container.action
			request_chain.append_array(command.direct_objects.map(func(d): return d.action))

		request_chain.append(command.action)

		var action_response := ""
		for action in request_chain:
			action_response = action.call(command, player)
			if not action_response.is_empty():
				response.append(action_response)
				break

		response = response.filter(func(r): return not r.is_empty())
		response = "\n".join(response)
		history.add_response(display_input, response)
		response = player.get_room().on_end_command(command, player)
		history.add_response(display_input, response)

		display_input = ""

func _on_Player_room_changed(room: Room):
	header.set_room_name(room.title)
