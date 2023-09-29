extends Command

const jump_death_messages = [
	"You should have looked before you leaped.",
	"In the movies, your life would be passing before your eyes.",
	"Geronimo..."
]

func action(command: Command, player: Player) -> String:
	if not command.direct_objects.is_empty():
		var thing = command.direct_objects[0]
		return _handle_jump_object(thing, player)

	var down_exit: Exit = player.get_room().exit_down
	if down_exit and not down_exit is DoorExit and not down_exit.can_exit(player):
		var responses = ["This was not a very safe place to try jumping."]
		responses.append(jump_death_messages.pick_random())
		responses.append(player.die())
		return "\n".join(responses)

	return Vocabulary.get_random_skip_response()

func _handle_jump_object(_thing: Thing, _player: Player) -> String:
	# TODO: handle jump over actor
	return "That would be a good trick."
