extends Node

const KEEP_EMPTY_TOKENS = false


func parse_input(input: String, player: Player) -> Array:
	if input.is_empty(): return []

	print("Raw input: %s" % input)

	# Wrap spaces around punctuation that should be treated as separate tokens
	var punctuation_tokens = [".", ",", "\""]
	for token in punctuation_tokens:
		input = input.replace(token, " %s " % token)
	
	Vocabulary.set_context(player)

	# Tokenize input and replace synonyms
	var tokens: Array = Array(input.split(" ", KEEP_EMPTY_TOKENS)).map(func(word): return Vocabulary.resolve(word))

	print("Processed input: %s" % " ".join(tokens))

	var commands = [] as Array[Command]

	var start_of_clause = 0
	var end_of_clause = _get_end_of_clause(tokens, start_of_clause)

	# Loop over each clause
	while end_of_clause <= len(tokens):
		var command = Command.new()
		# Parse input word by word
		for ptr in range(start_of_clause, end_of_clause):
			var word = tokens[ptr]

			# Buzzwords are either skipped entirely or have special handling where relevant
			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.BUZZWORD):
				continue

			var next_word = _find_next_word_in_clause(tokens, ptr + 1, end_of_clause)

			if word == "and":
				if _is_word_clause_terminator(tokens, ptr): continue
				if not Vocabulary.is_part_of_speech(next_word, Vocabulary.PartOfSpeech.ADJECTIVE) \
					and not Vocabulary.is_part_of_speech(next_word, Vocabulary.PartOfSpeech.OBJECT):
						command.error_response = "That sentence isn't one I recognize."
						break
				else:
					continue

			# Moving around may not provide a verb, so process directions first
			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.DIRECTION) \
				and ["", "walk"].has(command.verb):
					command.verb = "walk" # This may override the verb, but only if it's already "walk" so it's fine
					command.try_set_object(word)
					continue

			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.VERB):
				if not command.verb.is_empty():
					command.error_response = "You used the word %s in a way that I don't understand." % word
					break
				command.verb = word
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.PREPOSITION):
				if not Vocabulary.is_part_of_speech(next_word, Vocabulary.PartOfSpeech.OBJECT):
						command.error_response = "That sentence isn't one I recognize."
						break
				var preposition_was_set = command.try_set_preposition(word)
				if not preposition_was_set:
					command.error_response = "That sentence isn't one I recognize."
					break
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.OBJECT):
				var object_was_set = command.try_set_object(word)
				if not object_was_set:
					command.error_response = "There were too many nouns in that sentence."
					break
				if next_word == "and":
					command.set_and_flag()
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.ADJECTIVE):
				pass
			else:
				command.error_response = "I don't know the word \"%s\"." % word
				break

		commands.append(command)
		if not command.error_response.is_empty():
			break

		start_of_clause = end_of_clause + 1
		end_of_clause = _get_end_of_clause(tokens, start_of_clause)

	return commands

func _get_end_of_clause(tokens: Array, start: int) -> int:
	if start >= len(tokens): return len(tokens) + 1

	var end = tokens.find("then", start)
	if end == -1:
		end = len(tokens)

	var and_index = tokens.find("and", start)
	while(and_index > -1 and and_index < end):
		if _is_word_clause_terminator(tokens, and_index):
			end = and_index
			break;
		and_index = tokens.find("and", and_index + 1)

	return end

func _find_next_word_in_clause(tokens: Array, start: int, end: int = len(tokens)) -> String:
	for ptr in range(start, end):
		var word = tokens[ptr]
		if ["and", "then"].has(word):
			# "and" is not a buzzword, so we want to return it if it's not a terminator
			return word if not _is_word_clause_terminator(tokens, ptr) else ""
		if not Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.BUZZWORD):
			return word
	return ""

func _is_word_clause_terminator(tokens: Array, ptr: int) -> bool:
	var word = tokens[ptr]
	if word == "then": return true
	if word != "and": return false

	# if "and" is the last word it is a terminator so we're done
	if ptr + 1 == len(tokens): return true
	var next_word = tokens[ptr + 1]

	if ptr > 0 and Vocabulary.is_part_of_speech(tokens[ptr - 1], Vocabulary.PartOfSpeech.VERB):
		return true

	return Vocabulary.is_part_of_speech(next_word, Vocabulary.PartOfSpeech.DIRECTION) \
		or Vocabulary.is_part_of_speech(next_word, Vocabulary.PartOfSpeech.VERB)
