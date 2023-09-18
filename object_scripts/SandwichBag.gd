extends Bag

func action(command: Command, _player: Player) -> String:
	return "It smells of hot peppers." if command.verb == Vocabulary.Verbs.SMELL and contains_thing_by_name("lunch") else ""
