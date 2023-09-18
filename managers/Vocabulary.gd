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

class Verbs:
	const ALL_WORDS = [ ACTIVATE, ANSWER, APPLY, ATTACK, BACK, BLAST, BLOW, BOARD, BRUSH, BUG, BURN, CHOMP, CLIMB, CLOSE, COMMAND, COUNT, CROSS, CUT, CURSE, DEFLATE, DESTROY, DIG, DISEMBARK, DISENCHANT, DRINK, DROP, EAT, ECHO, ENCHANT, ENTER, EXIT, EXAMINE, EXORCISE, EXTINGUISH, FILL, FIND, FOLLOW, FROBOZZ, GIVE, HATCH, HELLO, INCANT, INFLAT, JUMP, KICK, KILL, STAB, KISS, KNOCK, LAUNCH, LEAN, LEAVE, LIGHT, LISTEN, LOCK, LOOK, LOWER, LUBRICATE, MAKE, MELT, MOVE, ROLL, MUMBLE, ODYSSEUS, OPEN, PICK, PLAY, PLUG, PLUGH, POKE, PUNCTURE, POUR, PRAY, PULL, PUMP, PUSH, PUT, RAISE, RAPE, READ, REPENT, RING, RUB, TALK, SAY, SEARCH, SEND, SHAKE, SKIP, SLIDE, SMELL, SPIN, SPRAY, SQUEEZE, STAND, STAY, STRIKE, SWIM, SWING, TAKE, TELL, THROW, TIE, TREASURE, TURN, UNLOCK, UNTIE, WAIT, WAKE, WALK, WAVE, WEAR, WIN, WIND, WISH, YELL, ZORK ]
	const ACTIVATE = "activate"
	const ANSWER = "answer"
	const APPLY = "apply"
	const ATTACK = "attack"
	const BACK = "back"
	const BLAST = "blast"
	const BLOW = "blow"
	const BOARD = "board"
	const BRIEF = "brief"
	const BRUSH = "brush"
	const BUG = "bug"
	const BURN = "burn"
	const CHOMP = "chomp"
	const CLIMB = "climb"
	const CLOSE = "close"
	const COMMAND = "command"
	const COUNT = "count"
	const CROSS = "cross"
	const CUT = "cut"
	const CURSE = "curse"
	const DEFLATE = "deflate"
	const DESTROY = "destroy"
	const DIG = "dig"
	const DISEMBARK = "disembark"
	const DISENCHANT = "disenchant"
	const DRINK = "drink"
	const DROP = "drop"
	const EAT = "eat"
	const ECHO = "echo"
	const ENCHANT = "enchant"
	const ENTER = "enter"
	const EXIT = "exit"
	const EXAMINE = "examine"
	const EXORCISE = "exorcise"
	const EXTINGUISH = "extinguish"
	const FILL = "fill"
	const FIND = "find"
	const FOLLOW = "follow"
	const FROBOZZ = "frobozz"
	const GIVE = "give"
	const HATCH = "hatch"
	const HELLO = "hello"
	const INCANT = "incant"
	const INFLAT = "inflat"
	const INVENTORY = "inventory"
	const JUMP = "jump"
	const KICK = "kick"
	const KILL = "kill"
	const STAB = "stab"
	const KISS = "kiss"
	const KNOCK = "knock"
	const LAUNCH = "launch"
	const LEAN = "lean"
	const LEAVE = "leave"
	const LIGHT = "light"
	const LISTEN = "listen"
	const LOCK = "lock"
	const LOOK = "look"
	const LOWER = "lower"
	const LUBRICATE = "lubricate"
	const MAKE = "make"
	const MELT = "melt"
	const MOVE = "move"
	const ROLL = "roll"
	const MUMBLE = "mumble"
	const ODYSSEUS = "odysseus"
	const OPEN = "open"
	const PICK = "pick"
	const PLAY = "play"
	const PLUG = "plug"
	const PLUGH = "plugh"
	const POKE = "poke"
	const PUNCTURE = "puncture"
	const POUR = "pour"
	const PRAY = "pray"
	const PULL = "pull"
	const PUMP = "pump"
	const PUSH = "push"
	const PUT = "put"
	const QUIT = "quit"
	const RAISE = "raise"
	const RAPE = "rape"
	const READ = "read"
	const REPENT = "repent"
	const RESTART = "restart"
	const RESTORE = "restore"
	const RING = "ring"
	const RUB = "rub"
	const SAVE = "save"
	const TALK = "talk"
	const SAY = "say"
	const SEARCH = "search"
	const SEND = "send"
	const SHAKE = "shake"
	const SKIP = "skip"
	const SLIDE = "slide"
	const SMELL = "smell"
	const SPIN = "spin"
	const SPRAY = "spray"
	const SQUEEZE = "squeeze"
	const STAND = "stand"
	const STAY = "stay"
	const STRIKE = "strike"
	const SUPER = "super"
	const SWIM = "swim"
	const SWING = "swing"
	const TAKE = "take"
	const TELL = "tell"
	const THROW = "throw"
	const TIE = "tie"
	const TREASURE = "treasure"
	const TURN = "turn"
	const UNLOCK = "unlock"
	const UNTIE = "untie"
	const VERBOSE = "verbose"
	const WAIT = "wait"
	const WAKE = "wake"
	const WALK = "walk"
	const WAVE = "wave"
	const WEAR = "wear"
	const WIN = "win"
	const WIND = "wind"
	const WISH = "wish"
	const YELL = "yell"
	const ZORK = "zork"

class Directions:
	const ALL_WORDS = [ NORTH, EAST, SOUTH, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, UP, DOWN, IN, OUT, LAND ]
	const NORTH = "north"
	const EAST = "east"
	const SOUTH = "south"
	const WEST = "west"
	const NORTHEAST = "northeast"
	const NORTHWEST = "northwest"
	const SOUTHEAST = "southeast"
	const SOUTHWEST = "southwest"
	const UP = "up"
	const DOWN = "down"
	const IN = "in"
	const OUT = "out"
	const LAND = "land"

class Prepositions:
	const ALL_WORDS = [ ABOUT, ACROSS, AROUND, AT, AWAY, BEHIND, DOWN, FOR, FROM, IN, OFF, ON, OUT, OVER, TO, UNDER, UP, WITH ]
	const ABOUT = "about"
	const ACROSS = "across"
	const AROUND = "around"
	const AT = "at"
	const AWAY = "away"
	const BEHIND = "behind"
	const DOWN = "down"
	const FOR = "for"
	const FROM = "from"
	const IN = "in"
	const OFF = "off"
	const ON = "on"
	const OUT = "out"
	const OVER = "over"
	const TO = "to"
	const UNDER = "under"
	const UP = "up"
	const WITH = "with"

class Buzzwords:
	const ALL_WORDS = [ A, AGAIN, ALL, AN, EXCEPT, G, HERE, IS, NO, OF, ONE, OOPS, QUOTE, THE, THEN, YES ]
	const A = "a"
	const AGAIN = "again"
	const ALL = "all"
	const AN = "an"
	const EXCEPT = "except"
	const G = "g"
	const HERE = "here"
	const IS = "is"
	const NO = "no"
	const OF = "of"
	const ONE = "one"
	const OOPS = "oops"
	const QUOTE = "\""
	const THE = "the"
	const THEN = "then"
	const YES = "yes"

# This should probably be in Rooms or something. It's not really Vocabulary, but there's nowhere
# else globally available on start and creating a new autoload just for this seems overkill.
class Groups:
	const GLOBAL_OBJECTS = "GlobalObjects"
	const OBJECTS = "Objects"
	const PLAYER = "Player"
	const ROOMS_AROUND_HOUSE = "Rooms-Around-House"

const _syntax_synonyms := {
		"and": [","],
		Verbs.ANSWER: ["reply"],
		Verbs.ATTACK: ["fight", "hurt", "injure", "hit"],
		Verbs.BRUSH: ["clean"],
		Verbs.BURN: ["incinerate", "ignite"],
		Verbs.CHOMP: ["lose", "barf"],
		Verbs.CLIMB: ["sit"],
		Verbs.CROSS: ["ford"],
		Verbs.CUT: ["slice", "pierce"],
		Verbs.CURSE: ["shit", "fuck", "damn"],
		Verbs.DESTROY: ["damage", "break", "block", "smash"],
		Directions.DOWN: ["d"],
		Verbs.DRINK: ["imbibe", "swallow"],
		Directions.EAST: ["e"],
		Verbs.EAT: ["consume", "taste", "bite"],
		Verbs.EXAMINE: ["describe", "what", "whats"],
		Buzzwords.EXCEPT: ["but"],
		Verbs.EXORCISE: ["banish", "cast", "drive", "begone"],
		Verbs.EXTINGUISH: ["douse"],
		Verbs.FIND: ["where", "seek", "see"],
		Verbs.FOLLOW: ["pursue", "chase", "come"],
		Verbs.GIVE: ["donate", "offer", "feed", "hand"],
		Verbs.HELLO: ["hi"],
		Directions.IN: ["inside", "into"],
		Verbs.INCANT: ["chant"],
		Verbs.INVENTORY: ["i"],
		Verbs.JUMP: ["leap", "dive"],
		Verbs.KICK: ["taunt"],
		Verbs.KILL: ["murder", "slay", "dispatch"],
		Verbs.KNOCK: ["rap"],
		Verbs.LOOK: ["l", "stare", "gaze"],
		Verbs.LUBRICATE: ["oil", "grease"],
		Verbs.MELT: ["liquify"],
		Verbs.MUMBLE: ["sigh"],
		Directions.NORTH: ["n"],
		Directions.NORTHEAST: ["ne"],
		Directions.NORTHWEST: ["nw"],
		Verbs.ODYSSEUS: ["ulysses"],
		Prepositions.ON: ["onto"],
		Verbs.PLUG: ["glue", "patch", "repair", "fix"],
		Verbs.PLUGH: ["xyzzy"],
		Verbs.POUR: ["spill"],
		Verbs.PULL: ["tug", "yank"],
		Verbs.PUSH: ["press"],
		Verbs.PUT: ["stuff", "insert", "place", "hide"],
		Verbs.QUIT: ["q"],
		Verbs.RAISE: ["lift"],
		Verbs.RAPE: ["molest"],
		Verbs.READ: ["skim"],
		Verbs.RING: ["peal"],
		Verbs.RUB: ["touch", "feel", "pat", "pet"],
		Verbs.SKIP: ["hop"],
		Verbs.SMELL: ["sniff"],
		Directions.SOUTH: ["s"],
		Verbs.SUPER: ["superbrief"],
		Directions.SOUTHEAST: ["se"],
		Directions.SOUTHWEST: ["sw"],
		Verbs.SWIM: ["bathe", "wade"],
		Verbs.SWING: ["thrust"],
		Verbs.TAKE: ["get", "hold", "carry", "remove", "grab", "catch"],
		Verbs.TELL: ["ask"],
		"then": ["."],
		Verbs.THROW: ["hurl", "chuck", "toss"],
		Verbs.TIE: ["fasten", "secure", "attach"],
		Verbs.TREASURE: ["temple"],
		Verbs.TURN: ["set", "flip", "shut"],
		Prepositions.UNDER: ["underneath", "beneath", "below"],
		Verbs.UNTIE: ["free", "release", "unfasten", "unattach", "unhook"],
		Directions.UP: ["u"],
		Verbs.WAIT: ["z"],
		Verbs.WAKE: ["awake", "surprise", "startle"],
		Verbs.WALK: ["go", "run", "proceed", "step"],
		Verbs.WAVE: ["brandish"],
		Directions.WEST: ["w"],
		Verbs.WIN: ["winnage"],
		Prepositions.WITH: ["using", "through", "thru"],
		Verbs.YELL: ["scream", "shout"],
		Buzzwords.YES: ["y"]
	}

const _dummy_responses := [ "Look around.", "Too late for that.", "Have your eyes checked." ]
const _yuk_responses := [ "A valiant attempt.", "You can't be serious.", "An interesting idea...", "What a concept!" ]
const _hello_responses := [ "Hello.", "Good day.", "Nice weather we've been having lately.", "Goodbye." ]
const _vowels := [ "a", "e", "i", "o", "u" ]

var _synonym_map := {}
var _commands := {}
var _prepositions := {}

func _init() -> void:
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
		if not command.first_preposition.is_empty():
			register_preposition(command.first_preposition)
		if not command.second_preposition.is_empty():
			register_preposition(command.second_preposition)

	for verb in _commands:
		_commands[verb].sort_custom(sort_commands)

func get_article(word: String) -> String:
	return Buzzwords.AN if _vowels.has(word.left(1)) else Buzzwords.A

func sort_commands(a: Command, b:Command) -> bool:
	if a.verb == b.verb:
		if a.first_preposition == b.first_preposition:
			return a.second_preposition.nocasecmp_to(b.second_preposition) > -1
		else:
			return a.first_preposition.nocasecmp_to(b.first_preposition) > -1
	else:
		return a.verb.nocasecmp_to(b.verb) > -1

func get_commands(verb: String) -> Array:
	return _commands[verb]

func get_random_dummy_response() -> String:
	return _dummy_responses.pick_random()

func get_random_yuk_response() -> String:
	return _yuk_responses.pick_random()

func resolve(word: String) -> String:
	return _synonym_map.get(word, word)

func register_preposition(prep: String) -> void:
	_prepositions[prep] = false

func is_part_of_speech(word: String, pos: PartOfSpeech) -> bool:
	match pos:
		PartOfSpeech.DIRECTION:
			return Directions.ALL_WORDS.has(word)
		PartOfSpeech.VERB:
			# We want to register verbs as we load commands rather than use the convenience
			# class above. That class is for eliminating magic strings when writing scripts.
			# Commands should not be dependent on it.
			return _commands.has(word)
		PartOfSpeech.PREPOSITION:
			# We want to register prepositions as we load commands rather than use the convenience
			# class above. That class is for eliminating magic strings when writing scripts.
			# Commands should not be dependent on it.
			return _prepositions.has(word)
		PartOfSpeech.ADJECTIVE:
			return get_tree().get_nodes_in_group(Groups.OBJECTS).any(func(o: Thing): return o.adjectives.has(word))
		PartOfSpeech.OBJECT:
			return get_tree().get_nodes_in_group(Groups.OBJECTS).any(func(o: Thing): return o.nouns.has(word))
		PartOfSpeech.BUZZWORD:
			return Buzzwords.ALL_WORDS.has(word)

	return false

func register_synonyms(word: String, synonyms: Array) -> void:
	for synonym in synonyms:
		if _synonym_map.has(synonym):
			push_warning("Warning: duplicate synonym '%s' registered to '%s' and '%s'." % [synonym, _synonym_map[synonym], word])
		_synonym_map[synonym] = word
