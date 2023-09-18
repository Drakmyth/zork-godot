extends Thing

@export var moved: bool
@export_node_path("Door") var trap_door: NodePath

func action(command: Command, player: Player) -> String:
	var td = get_node(trap_door) as Door
	
	match command.verb:
		Vocabulary.Verbs.RAISE:
			var discovery = ", but in trying to take it you have noticed an irregularity beneath it." if not moved else "."
			return "The rug is too heavy to lift%s" % discovery
		Vocabulary.Verbs.MOVE:
			return _handle_move(command, player)
		Vocabulary.Verbs.PUSH:
			return _handle_move(command, player)
		Vocabulary.Verbs.TAKE:
			return "The rug is extremely heavy and cannot be carried."
		Vocabulary.Verbs.LOOK:
			if command.first_preposition == Vocabulary.Prepositions.UNDER and not moved and not td.is_open():
				return "Underneath the rug is a closed trap door. As you drop the corner of the rug, the trap door is once again concealed from view."
		Vocabulary.Vergs.CLIMB:
			if command.first_preposition == Vocabulary.Prepositions.ON:
				if not moved and not td.is_open():
					return "As you sit, you notice an irregularity underneath it. Rather than be uncomfortable, you stand up again."
				return "I suppose you think it's a magic carpet?"
	return ""

func _handle_move(_command: Command, _player: Player) -> String:
	return ""
