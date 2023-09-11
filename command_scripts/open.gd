extends Command

func action(command: Command, _player: Player) -> String:
	# TODO: if container with > 0 capacity:
	var object = command.direct_objects[0]
	if object.is_class("Door"):
		var door = object as Door
		if door.is_open():
			return "It is already open."
		else:
			door.open = true
			return "The %s opens." % door.description
	else:
		return "You must tell me how to do that to a %s." % object.description
