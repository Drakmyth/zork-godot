extends Bag

func action(command: Command, _player: Player) -> String:
	if command.verb == Vocabulary.Verbs.TAKE and command.direct_objects.has(self):
		return "It is securely anchored."

	return ""
