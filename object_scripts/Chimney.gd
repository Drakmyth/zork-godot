extends Stairs

func action(command: Command, _player: Player) -> String:
	if command.verb == Vocabulary.Verbs.EXAMINE:
		return "The chimney leads %s, and looks climbable." % ("upward" if leads_up else "downward")

	return ""

