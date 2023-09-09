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

const _syntax_directions := ["north", "east", "west", "south", "ne", "nw", "se", "sw", "up", "down", "in", "out", "land"]
const _syntax_buzzwords := ["again", "g", "oops", "a", "an", "the", "is", "of", "then", "all", "one", "except", "\"", "yes", "no", "here"]
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
		"ne": ["northeast"],
		"north": ["n"],
		"nw": ["northwest"],
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
		"se": ["southeast"],
		"skip": ["hop"],
		"smell": ["sniff"],
		"south": ["s"],
		"super": ["superbrief"],
		"sw": ["southwest"],
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
var _adjectives := {}
var _objects := {}
var _buzzwords := {}

func _init() -> void:
	for word in _syntax_directions:
		register_direction(word)
	for word in _syntax_buzzwords:
		register_buzzword(word)
	for word in _syntax_synonyms:
		register_synonyms(word, _syntax_synonyms[word])

	# Debug objects to test the parser
	breakpoint
	register_object("tree")
	register_object("log")
	register_object("lamp")
	register_adjective("green")

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

func get_command(verb):
	return _commands[verb][0]

func resolve(word: String) -> String:
	return _synonym_map.get(word, word)

func register_direction(dir: String) -> void:
	_directions[dir] = false

func register_preposition(prep: String) -> void:
	_prepositions[prep] = false

func register_adjective(adj: String) -> void:
	_adjectives[adj] = false

func register_object(obj: String) -> void:
	_objects[obj] = false

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
			return _adjectives.has(word)
		PartOfSpeech.OBJECT:
			return _objects.has(word)
		PartOfSpeech.BUZZWORD:
			return _buzzwords.has(word)
		_:
			return false

func register_synonyms(word: String, synonyms: Array) -> void:
	for synonym in synonyms:
		if _synonym_map.has(synonym):
			push_warning("Warning: duplicate synonym '%s' registered to '%s' and '%s'." % [synonym, _synonym_map[synonym], word])
		_synonym_map[synonym] = word
