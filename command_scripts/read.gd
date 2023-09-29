extends Command

func action(command: Command, _player: Player) -> String:
	return command.direct_objects[0].read()

func preaction(command: Command, player: Player) -> String:
	if not player.can_see():
		return "It is impossible to read in the dark."

	var indirect_object = command.indirect_objects[0] if not command.indirect_objects.is_empty() else null
	if indirect_object and not indirect_object.is_transparent():
		return "How does one look through a %s?" % indirect_object.description

	return ""
