extends Thing

func action(command: Command, _player: Player) -> String:
	match command.verb:
		Vocabulary.Verbs.FIND: return "There is no grue here, but I'm sure there is at least one
			lurking in the darkness nearby. I wouldn't let my light go out if I were you!"
		Vocabulary.Verbs.LISTEN: return "It makes no sound but is always lurking in the darkness nearby."
	return ""
