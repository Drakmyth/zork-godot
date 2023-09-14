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
		command.max_direct_objects = -1
		command.max_indirect_objects = -1
		var adj_flag = false
		# Parse input word by word
		for ptr in range(start_of_clause, end_of_clause):
			var word = tokens[ptr]

			# Buzzwords are either skipped entirely or have special handling where relevant
			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.BUZZWORD):
				continue

			var next_word = _find_next_word_in_clause(tokens, ptr + 1, end_of_clause)

			if word == "and":
				if _is_word_clause_terminator(tokens, ptr): continue
				if not _in_noun_phrase(next_word):
					command.error_response = "That sentence isn't one I recognize."
					break
				else:
					continue

			# Moving around may not provide a verb, so process directions first
			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.DIRECTION) \
				and ["", Vocabulary.Verbs.WALK].has(command.verb):
					command.verb = Vocabulary.Verbs.WALK # This may override the verb, but only if it's already "walk" so it's fine
					var direction = Thing.new()
					direction.description = word
					command.try_set_object(direction)
					continue

			if Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.VERB) and command.verb.is_empty():
				command.verb = word
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.PREPOSITION):
				if not _in_noun_phrase(next_word):
					command.error_response = "That sentence isn't one I recognize."
					break
				var preposition_was_set = command.try_set_preposition(word)
				if not preposition_was_set:
					command.error_response = "That sentence isn't one I recognize."
					break
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.OBJECT):
				if not adj_flag:
					var objects = player.get_things(word)
					if len(objects) == 0:
						command.error_response = "You can't see any %s here." % word
						break
					# TODO: elif len(objects) > 1:
					var object_was_set = command.try_set_object(objects[0])
					if not object_was_set:
						command.error_response = "There were too many nouns in that sentence."
						break
				adj_flag = false
				if next_word == "and":
					command.set_and_flag()
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.ADJECTIVE):
				var noun = next_word if Vocabulary.is_part_of_speech(next_word, Vocabulary.PartOfSpeech.OBJECT) else ""
				var objects = player.get_things(noun, word)
				if len(objects) == 0:
					command.error_response = "You can't see any %s here" % " ".join([word, noun])
					break
				# TODO: elif len(objects) > 1:
				var object_was_set = command.try_set_object(objects[0])
				if not object_was_set:
					command.error_response = "There were too many nouns in that sentence."
					break
				adj_flag = true
			elif Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.VERB):
				command.error_response = "You used the word %s in a way I don't understand." % word
				break
			else:
				command.error_response = "I don't know the word \"%s\"." % word
				break


		if command.verb.is_empty():
			command.error_response = "There was no verb in that sentence!"

		if command.error_response.is_empty():
			command = _match_to_known_command(command)
			commands.append(command)
		else:
			commands.append(command)
			break

		start_of_clause = end_of_clause + 1
		end_of_clause = _get_end_of_clause(tokens, start_of_clause)

	return commands

func _in_noun_phrase(word: String) -> bool:
	return Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.ADJECTIVE) \
		or Vocabulary.is_part_of_speech(word, Vocabulary.PartOfSpeech.OBJECT)

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

func _match_to_known_command(parsed_command: Command) -> Command:
	var matched_commands = Vocabulary.get_commands(parsed_command.verb)
	var last_best_match = matched_commands[0]

	if len(matched_commands) > 1:
		matched_commands = matched_commands.filter(func(c): return c.first_preposition == parsed_command.first_preposition)
		if not matched_commands.is_empty(): last_best_match = matched_commands[0]

	if len(matched_commands) > 1:
		matched_commands = matched_commands.filter(func(c): return c.second_preposition == parsed_command.second_preposition)
		if not matched_commands.is_empty(): last_best_match = matched_commands[0]

	if not parsed_command.second_preposition.is_empty() \
		and (parsed_command.second_preposition != last_best_match.second_preposition or parsed_command.first_preposition != last_best_match.first_preposition):
		return Command.ErrorCommand("That sentence isn't one I recognize.")
	elif not parsed_command.first_preposition.is_empty() and parsed_command.first_preposition != last_best_match.first_preposition:
		return Command.ErrorCommand("That sentence isn't one I recognize.")

	return last_best_match.duplicate().populate_from(parsed_command)
