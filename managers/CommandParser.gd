extends Node

const KEEP_EMPTY_TOKENS = false


func parse_command(input: String) -> Array[Command]:

	print("Raw input: %s" % input)

	# Wrap spaces around punctuation that starts a new clause
	var punctuation_tokens = [".", ",", "\""]
	for token in punctuation_tokens:
		input = input.replace(token, " %s " % token)

	# Tokenize input and replace synonyms
	var tokens = Array(input.split(" ", KEEP_EMPTY_TOKENS)).map(func(word): return Vocabulary.resolve(word))

	print("Processed input: %s" % " ".join(tokens))

	# No input, no command
	if len(tokens) == 0:
		print("I beg your pardon?")
		return []

	var commands = [] as Array[Command]
	var command = Command.new()

	var words_remaining = len(tokens)

	# Parse input word by word
	for ptr in range(len(tokens)):
		var word = tokens[ptr]
		words_remaining -= 1
		var next_word = tokens[ptr + 1] if words_remaining > 0 else ""

		# Buzzwords are either skipped entirely or have special handling where relevant
		if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.BUZZWORD):
			continue

		# Moving around may not provide a verb, so process movement first
		if _check_walk(command, word, next_word):
			command.verb = "walk" # This may override the verb, but only if it's already "walk" so it's fine
			command.object1 = word
			print("Command: %s" % command.as_phrase())
			commands.append(command)
			if next_word == "then":
				command = Command.new()
		# All other commands require a verb to be specified
		elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.VERB):
			command.verb = word
	return commands

func _check_walk(command:Command, word: String, next_word: String) -> bool:
	if not Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.DIRECTION): return false
	if not ["", "walk"].has(command.verb): return false
	if next_word == "": return true
	return next_word == "then"
