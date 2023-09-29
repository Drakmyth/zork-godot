extends Thing

func action(command: Command, player: Player) -> String:
	var room = player.get_room()

	if not room.is_in_group(Vocabulary.Groups.ROOMS_AROUND_HOUSE) and command.verb != Vocabulary.Verbs.FIND:
		return "You're not at the house."

	match(command.verb):
		Vocabulary.Verbs.FIND:
			return _handle_find(player)
		Vocabulary.Verbs.ENTER:
			return _handle_open(player)
		Vocabulary.Verbs.OPEN:
			return _handle_open(player)
		Vocabulary.Verbs.BURN:
			return "You must be joking."
		Vocabulary.Verbs.WALK:
			return _handle_walk(command, player)

	return ""

func _handle_find(player: Player) -> String:
	var room = player.get_room()
	if room.is_in_group(Vocabulary.Groups.ROOMS_AROUND_HOUSE):
		return "It's right here! Are you blind or something?"
	elif room.name == "clearing":
		return "It seems to be to the west"
	else:
		return "It was here just a minute ago...."

func _handle_open(player: Player) -> String:
	var room = player.get_room()
	if room.name != "east-of-house": return "I can't see how to get in from here."

	var kitchen_window = room.get_local_object("kitchen-window") as Door
	if kitchen_window.is_open():
		var kitchen = room.get_node("../kitchen")
		return player.move_to(kitchen)
	else:
		return "The window is closed."

func _handle_walk(command:Command, player: Player) -> String:
	if command.preposition != Vocabulary.Prepositions.AROUND: return ""

	return player.move_to_next_room_in_group(Vocabulary.Groups.ROOMS_AROUND_HOUSE)
