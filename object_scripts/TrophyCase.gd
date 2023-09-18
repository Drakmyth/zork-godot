extends Bag

func action(command: Command, _player: Player) -> String:
	return "The trophy case is securely fastened to the wall." if command.verb == Vocabulary.Verbs.TAKE and command.direct_objects.has(self) else ""

