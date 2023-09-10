extends Node

enum PartOfSpeech {
	UNKNOWN = 0,
	DIRECTION,
	VERB,
	PREPOSITION,
	ADJECTIVE,
	OBJECT,
	BUZZWORD
}

const _syntax_directions := ["north", "east", "south", "west", "northeast", "northwest", "southeast", "southwest", "up", "down", "in", "out", "land"]
const _syntax_buzzwords := ["a", "again", "all", "an", "except", "g", "here", "is", "no", "of", "one", "oops", "the", "then", "yes", "\""]
const _syntax_synonyms := {
		"and": [","],
		"answer": ["reply"],
		"attack": ["fight", "hurt", "injure", "hit"],
		"brush": ["clean"],
		"burn": ["incinerate", "ignite"],
		"chomp": ["lose", "barf"],
		"climb": ["sit"],
		"cross": ["ford"],
		"cut": ["slice", "pierce"],
		"curse": ["shit", "fuck", "damn"],
		"destroy": ["damage", "break", "block", "smash"],
		"down": ["d"],
		"drink": ["imbibe", "swallow"],
		"east": ["e"],
		"eat": ["consume", "taste", "bite"],
		"examine": ["describe", "what", "whats"],
		"except": ["but"],
		"exorcise": ["banish", "cast", "drive", "begone"],
		"extinguish": ["douse"],
		"find": ["where", "seek", "see"],
		"follow": ["pursue", "chase", "come"],
		"give": ["donate", "offer", "feed", "hand"],
		"hello": ["hi"],
		"in": ["inside", "into"],
		"incant": ["chant"],
		"inventory": ["i"],
		"jump": ["leap", "dive"],
		"kick": ["taunt"],
		"kill": ["murder", "slay", "dispatch"],
		"knock": ["rap"],
		"look": ["l", "stare", "gaze"],
		"lubricate": ["oil", "grease"],
		"melt": ["liquify"],
		"mumble": ["sigh"],
		"north": ["n"],
		"northeast": ["ne"],
		"northwest": ["nw"],
		"odysseus": ["ulysses"],
		"on": ["onto"],
		"plug": ["glue", "patch", "repair", "fix"],
		"plugh": ["xyzzy"],
		"pour": ["spill"],
		"pull": ["tug", "yank"],
		"push": ["press"],
		"put": ["stuff", "insert", "place", "hide"],
		"quit": ["q"],
		"raise": ["lift"],
		"rape": ["molest"],
		"read": ["skim"],
		"ring": ["peal"],
		"rub": ["touch", "feel", "pat", "pet"],
		"skip": ["hop"],
		"smell": ["sniff"],
		"south": ["s"],
		"super": ["superbrief"],
		"southeast": ["se"],
		"southwest": ["sw"],
		"swim": ["bathe", "wade"],
		"swing": ["thrust"],
		"take": ["get", "hold", "carry", "remove", "grab", "catch"],
		"tell": ["ask"],
		"then": ["."],
		"throw": ["hurl", "chuck", "toss"],
		"tie": ["fasten", "secure", "attach"],
		"treasure": ["temple"],
		"turn": ["set", "flip", "shut"],
		"under": ["underneath", "beneath", "below"],
		"untie": ["free", "release", "unfasten", "unattach", "unhook"],
		"up": ["u"],
		"wait": ["z"],
		"wake": ["awake", "surprise", "startle"],
		"walk": ["go", "run", "proceed", "step"],
		"wave": ["brandish"],
		"west": ["w"],
		"win": ["winnage"],
		"with": ["using", "through", "thru"],
		"yell": ["scream", "shout"],
		"yes": ["y"]
	}

var _synonym_map := {}
var _commands := {}

var _directions := {}
var _prepositions := {}
var _buzzwords := {}
# TODO: build global list of objects and adjectives to provide better error responses for things not currently visible to the player

var _context: Player

func _init() -> void:
	for word in _syntax_directions:
		register_direction(word)
	for word in _syntax_buzzwords:
		register_buzzword(word)
	for word in _syntax_synonyms:
		register_synonyms(word, _syntax_synonyms[word])

	const commands_dir := "res://commands"
	var files := DirAccess.get_files_at(commands_dir)
	for filepath in files:
		var command := load("%s/%s" % [commands_dir, filepath]) as Command
		print("Loaded '%s'" % command.as_string())
		if _commands.has(command.verb):
			_commands[command.verb].append(command)
		else:
			_commands[command.verb] = [command]
		if not command.preposition1.is_empty():
			register_preposition(command.preposition1)
		if not command.preposition2.is_empty():
			register_preposition(command.preposition2)
	print("")

func set_context(player: Player) -> void:
	_context = player

func get_command(verb: String) -> Command:
	# TODO: Retrieve command that matches syntax
	return _commands[verb][0]

func resolve(word: String) -> String:
	return _synonym_map.get(word, word)

func register_direction(dir: String) -> void:
	_directions[dir] = false

func register_preposition(prep: String) -> void:
	_prepositions[prep] = false

func register_buzzword(buzz: String) -> void:
	_buzzwords[buzz] = false

func is_part_of_speech(word: String, pos: PartOfSpeech) -> bool:
	match pos:
		PartOfSpeech.DIRECTION:
			return _directions.has(word)
		PartOfSpeech.VERB:
			return _commands.has(word)
		PartOfSpeech.PREPOSITION:
			return _prepositions.has(word)
		PartOfSpeech.ADJECTIVE:
			return _context.is_known_adjective(word)
		PartOfSpeech.OBJECT:
			return _context.is_known_object(word)
		PartOfSpeech.BUZZWORD:
			return _buzzwords.has(word)

	return false

func register_synonyms(word: String, synonyms: Array) -> void:
	for synonym in synonyms:
		if _synonym_map.has(synonym):
			push_warning("Warning: duplicate synonym '%s' registered to '%s' and '%s'." % [synonym, _synonym_map[synonym], word])
		_synonym_map[synonym] = word
