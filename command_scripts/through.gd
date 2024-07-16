extends Command

func action(command: Command, player: Player) -> String:
	var obj = command.direct_objects[0]
	if obj is Door:
		var exit = player.get_room().get_door_exit(obj)
		return player.move_exit(exit)
	if not obj.can_be_taken(): return "You hit your head against the %s as you attempt this feat." % [obj.description]
	return Vocabulary.get_random_yuk_response()
