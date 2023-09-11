extends Command

const DEFAULT_RESPONSE = "You cannot close that."

func action(command: Command, player: Player) -> String:
	var object = command.direct_objects[0]

	if object is Bag:
		return _handle_bag(object as Bag, command, player)
	elif object is Door:
		return _handle_door(object as Door, command, player)
	else:
		return "You must tell me how to do that to a %s." % object.description

func _handle_bag(bag: Bag, _command: Command, _player: Player) -> String:
	if bag.behavior_flags & Bag.FLAG_SURFACE: return DEFAULT_RESPONSE
	if bag.capacity <= 0: return DEFAULT_RESPONSE

	if bag.is_open():
		bag.open = false
		# TODO: if not room.is_lit(): return "Closed.\nIt is now pitch black."
		return "Closed."
	else:
		return "It is already closed."

func _handle_door(door: Door, _command: Command, _player: Player) -> String:
	if door.is_open():
		door.open = false
		return "The %s is now closed." % door.description
	else:
		return "It is already closed."
