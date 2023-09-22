extends Command

func action(command: Command, player: Player) -> String:
	var obj = command.direct_objects[0]
	if not obj.parser_flags & Thing.FLAG_KINDLING: return "You can't burn a %s." % obj.description

	var riding = obj.is_ancestor_of(player)
	obj.queue_free()
	if riding or player.is_carrying(obj):
		# TODO: death
		return "The %s catches fire. Unfortunately, you were %s it at the time." % [obj.description, "in" if riding else "holding"]

	return "The %s catches fire and is consumed." % obj.description

func preaction(command: Command, _player: Player) -> String:
	if command.indirect_objects.is_empty():
		command.instantaneous = true
		return "You didn't say with what!"

	var obj = command.indirect_objects[0]
	return "With a %s??!?" % obj.description if not obj.parser_flags & Thing.FLAG_FLAMING else ""
