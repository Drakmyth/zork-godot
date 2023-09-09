extends Node

const KEEP_EMPTY_TOKENS = false


func parse_input(input: String) -> Array[Command]:

	print("Raw input: %s" % input)

	# Wrap spaces around punctuation that starts a new phrase
	var punctuation_tokens = [".", ",", "\""]
	for token in punctuation_tokens:
		input = input.replace(token, " %s " % token)

	# Tokenize input and replace synonyms
	var tokens: Array = Array(input.split(" ", KEEP_EMPTY_TOKENS)).map(func(word): return Vocabulary.resolve(word))

	print("Processed input: %s" % " ".join(tokens))

	# No input, no command
	if len(tokens) == 0:
		print("I beg your pardon?")
		return []

	var commands = [] as Array[Command]

	var start_of_phrase = 0
	var end_of_phrase = _get_end_of_phrase(tokens, start_of_phrase)

	# Loop over each phrase
	while end_of_phrase <= len(tokens):
		var command = Command.new()
		# Parse input word by word
		for ptr in range(start_of_phrase, end_of_phrase):
			var word = tokens[ptr]

			# Buzzwords are either skipped entirely or have special handling where relevant
			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.BUZZWORD):
				continue

			var next_word = _find_next_word_in_phrase(tokens, ptr + 1, end_of_phrase)

			# Moving around may not provide a verb, so process directions first
			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.DIRECTION) \
				and ["", "walk"].has(command.verb):
					command.verb = "walk" # This may override the verb, but only if it's already "walk" so it's fine
					command.object1 = word
					if next_word == "":
						commands.append(command)
					continue

			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.VERB):
				if command.verb != "":
					print("You used the word %s in a way that I don't understand." % word)
					break
				command.verb = word
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.PREPOSITION):
				if not Vocabulary.is_part_of_speech(next_word, Vocabulary.PartOfSpeech.OBJECT):
						print("That sentence isn't one I recognize.")
						break
				var preposition_was_set = command.try_set_preposition(word)
				if not preposition_was_set:
					print("That sentence isn't one I recognize.")
					break
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.OBJECT):
				var object_was_set = command.try_set_object(word)
				if not object_was_set:
					print("There were too many nouns in that sentence.")
					break
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.ADJECTIVE):
				pass
			else:
				print("I don't know the word \"%s\"." % word)
				break

			if next_word == "":
				commands.append(command)

		start_of_phrase = end_of_phrase + 1
		end_of_phrase = _get_end_of_phrase(tokens, start_of_phrase)

	return commands

func _get_end_of_phrase(tokens: Array, start: int) -> int:
	if start >= len(tokens): return len(tokens) + 1

	var end = tokens.find("then", start)
	if end == -1:
		end = len(tokens)
	return end

func _find_next_word_in_phrase(tokens: Array, start: int, end: int = len(tokens)) -> String:
	for ptr in range(start, end):
		var word = tokens[ptr]
		if not Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.BUZZWORD):
			return word
		if word == "then":
			return ""
	return ""
