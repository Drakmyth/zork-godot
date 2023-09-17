extends Command

func action(command: Command, player: Player) -> String:
	var thing: Thing = command.direct_objects[0]
	var take_response = player.take(thing)
	if take_response.is_empty():
		return "Taken."

	return take_response

func preaction(command: Command, player: Player) -> String:
	var thing: Thing = command.direct_objects[0]
	if player.is_carrying(thing):
		return "You already have that!"

	if thing.is_in_bag() and not thing.get_parent().is_open():
		return "You can't reach something that's inside a closed container."

	if len(command.indirect_objects) > 0 and thing.get_parent() != command.indirect_objects[0]:
		return "The %s isn't in the %s." % [thing.description, command.indirect_objects[0].description]

	if player.get_parent() == thing:
		return "You're inside of it!"

	return ""
