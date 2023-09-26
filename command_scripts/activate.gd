extends Command

func action(command: Command, _player: Player) -> String:
	var thing = command.direct_objects[0]
	if thing.can_be_onoff():
		if thing.is_activated(): return "It is already on."
		thing.state_flags |= Thing.StateFlags.ACTIVATED
		return "The %s is now on." % thing.description
	elif thing.can_be_burned():
		return "If you wish to burn the %s, you should say so." % thing.description

	return "You can't turn that on." 
