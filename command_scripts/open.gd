extends Command

const DEFAULT_RESPONSE = "You must tell me how to do that to a %s."

func action(command: Command, player: Player) -> String:
	var object = command.direct_objects[0]

	if object is Bag:
		return _handle_bag(object, command, player)
	elif object is Door:
		return _handle_door(object, command, player)
	else:
		return DEFAULT_RESPONSE % object.description

func _handle_bag(bag: Bag, _command: Command, _player: Player) -> String:
	if bag.capacity <= 0: return DEFAULT_RESPONSE % bag.description
	if bag.is_open(): return "It is already open."

	bag.open = true
	bag.parser_flags |= Thing.FLAG_TOUCHED

	var contents = bag.find_things()

	if contents.is_empty() or bag.behavior_flags & Bag.FLAG_TRANSPARENT:
		return "Opened."
	elif len(contents) == 1 and not contents[0].parser_flags & Thing.FLAG_TOUCHED and not contents[0].first_description.is_empty():
		return "The %s opens.\n%s" % [bag.description, contents[0].first_description]
	else:
		if len(contents) == 1:
			# TODO: Set "IT" to contents[0]
			pass
		return "Opening the %s reveals %s." % [bag.description, bag.list_contents()]

func _handle_door(door: Door, _command: Command, _player: Player) -> String:
	if door.is_open(): return "It is already open."

	door.open = true
	return "The %s opens." % door.description
