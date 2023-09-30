extends Command

func action(command: Command, player: Player) -> String:
	var obj = command.direct_objects[0]
	if not obj.can_be_burned(): return "You can't burn a %s." % obj.description

	var riding = obj.is_ancestor_of(player)
	obj.queue_free()
	if riding or player.is_carrying(obj):
		var response = []
		response.append("The %s catches fire. Unfortunately, you were %s it at the time." % [obj.description, "in" if riding else "holding"])
		response.append(player.die())
		return "\n".join(response)

	return "The %s catches fire and is consumed." % obj.description

func preaction(command: Command, _player: Player) -> String:
	if command.indirect_objects.is_empty():
		command.instantaneous = true
		return "You didn't say with what!"

	var obj = command.indirect_objects[0]
	return "With a %s??!?" % obj.description if not obj.is_flaming() else ""
