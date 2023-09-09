extends Node

const KEEP_EMPTY_TOKENS = false


func parse_command(input: String) -> Array[Command]:

	print("Raw input: %s" % input)

	var punctuation_tokens = [".", ",", "\""]
	for token in punctuation_tokens:
		input = input.replace(token, " %s " % token)

	var tokens = Array(input.split(" ", KEEP_EMPTY_TOKENS)).map(func(word): return Vocabulary.resolve(word))

	print("Processed input: %s" % " ".join(tokens))
	if len(tokens) == 0:
		print("I beg your pardon?\n")
		return []

	var commands = [] as Array[Command]
	var command = Command.new()

	var words_remaining = len(tokens)

	for ptr in range(len(tokens)):
		var word = Vocabulary.resolve(tokens[ptr])
		words_remaining -= 1
		var next_word = Vocabulary.resolve(tokens[ptr + 1]) if words_remaining > 0 else ""

		if _check_walk(command, word, next_word):
			command.verb = "walk"
			command.object1 = word
			print("Command: %s" % command.as_phrase())
			commands.append(command)
			if next_word == "then":
				command = Command.new()
		elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.VERB):
			command.verb = word
	return commands

func _check_walk(command:Command, word: String, next_word: String) -> bool:
	if not Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.DIRECTION): return false
	if not ["", "walk"].has(command.verb): return false
	if next_word == "": return true
	return next_word == "then"
