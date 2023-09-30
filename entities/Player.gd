extends GameObject
class_name Player

const ROOMS_PATH = "/root/Game/Rooms"
const LOAD_ALLOWED = 100
const LOAD_MAX = 100
const SCORE_MAX = 350

enum DescriptionMode {
	Verbose,
	Brief,
	Superbrief
}

@export var description_mode: DescriptionMode = DescriptionMode.Brief
@export_range(0, SCORE_MAX, 1) var score = 0 : set = _set_score
@export_range(0, 0, 1, "or_greater") var moves = 0 : set = _set_moves
@export var dead: bool = false
@export var deaths: int = 0
@export var lucky: bool = true

signal room_changed
signal score_changed
signal moves_changed

func _set_score(_score: int) -> void:
	score = _score
	score_changed.emit(score)

func _set_moves(_moves: int) -> void:
	moves = _moves
	moves_changed.emit(moves)

func get_room() -> Room:
	# TODO: Walk up tree in case Player is "inside" something
	return get_parent() as Room

func get_rank() -> String:
	if score >= SCORE_MAX: return "Master Adventurer"
	elif score > 330: return "Wizard"
	elif score > 300: return "Master"
	elif score > 200: return "Adventurer"
	elif score > 100: return "Junior Adventurer"
	elif score > 50: return "Novice Adventurer"
	elif score > 25: return "Amateur Adventurer"

	return "Beginner"

func can_see() -> bool:
	return get_room().is_lit() or has_light()

func action(command: Command, _player: Player) -> String:
	if not dead: return ""

	const ATTACK_MESSAGE = "All such attacks are vain in your condition."
	const INTERACT_MESSAGE = "Even such an action is beyond your capabilities."
	const INVENTORY_MESSAGE = "You have no possessions."

	match command.verb:
		Vocabulary.Verbs.WALK: return ""
		Vocabulary.Verbs.BRIEF: return ""
		Vocabulary.Verbs.VERBOSE: return ""
		Vocabulary.Verbs.SUPER: return ""
		Vocabulary.Verbs.SAVE: return ""
		Vocabulary.Verbs.RESTORE: return ""
		Vocabulary.Verbs.RESTART: return ""
		Vocabulary.Verbs.QUIT: return ""
		Vocabulary.Verbs.ATTACK: return ATTACK_MESSAGE
		Vocabulary.Verbs.DESTROY: return ATTACK_MESSAGE
		Vocabulary.Verbs.WAKE: return ATTACK_MESSAGE
		Vocabulary.Verbs.SWING: return ATTACK_MESSAGE
		Vocabulary.Verbs.OPEN: return INTERACT_MESSAGE
		Vocabulary.Verbs.CLOSE: return INTERACT_MESSAGE
		Vocabulary.Verbs.EAT: return INTERACT_MESSAGE
		Vocabulary.Verbs.DRINK: return INTERACT_MESSAGE
		Vocabulary.Verbs.INFLATE: return INTERACT_MESSAGE
		Vocabulary.Verbs.DEFLATE: return INTERACT_MESSAGE
		Vocabulary.Verbs.TURN: return INTERACT_MESSAGE
		Vocabulary.Verbs.BURN: return INTERACT_MESSAGE
		Vocabulary.Verbs.TIE: return INTERACT_MESSAGE
		Vocabulary.Verbs.UNTIE: return INTERACT_MESSAGE
		Vocabulary.Verbs.RUB: return INTERACT_MESSAGE
		Vocabulary.Verbs.WAIT: return "Might as well. You've got an eternity."
		Vocabulary.Verbs.ACTIVATE: return "You need no light to guide you."
		Vocabulary.Verbs.SCORE: return "You're dead! How can you think of your score?"
		Vocabulary.Verbs.TAKE: return "Your hand passes through its object."
		Vocabulary.Verbs.DROP: return INVENTORY_MESSAGE
		Vocabulary.Verbs.THROW: return INVENTORY_MESSAGE
		Vocabulary.Verbs.INVENTORY: return INVENTORY_MESSAGE
		Vocabulary.Verbs.DIAGNOSE: return "You are dead."
		Vocabulary.Verbs.LOOK: return _handle_look_while_dead()
		Vocabulary.Verbs.PRAY:
			return "Your prayers are not heard."
	return "You can't even do that."

func die() -> String:
	var responses = []
	if not lucky:
		responses.append("Bad luck, huh?")
	score -= 10
	responses.append(" \n    ****  You have died  ****\n ")

	if dead:
		DialogManager.quit("It takes a talented person to be killed while already dead. YOU are such a talent. \
Unfortunately, it takes a talented person to deal with it. I am not such a talent. Sorry.")
		return "\n".join(responses)

	if deaths >= 2:
		DialogManager.quit("You clearly are a suicidal maniac. We don't allow psychotics in the cave, \
since they may harm other adventurers. Your remains will be installed in the Land of the Living Dead, \
where your fellow adventurers may gloat over them.")
		return "\n".join(responses)

	deaths += 1

	var altar_room = get_node(ROOMS_PATH).find_child("south-temple", false)
	if altar_room and altar_room.is_visited():
		# var hades_room = get_node(ROOMS_PATH).find_child("entrance-to-hades", false)
		responses.append("As you take your last breath, you feel relieved of your burdens. The \
feeling passes as you find yourself before the gates of Hell, where the spirits jeer at you and \
deny you entry. Your senses are disturbed. The objects in the dungeon appear indistinct, bleached \
of color, even unreal.\n ")
		dead = true
		# TODO: responses.append(move_to(hades_room))
	else:
		var forest_room = get_node(ROOMS_PATH).find_child("west-forest", false)
		responses.append("Now, let's take a look here... Well, you probably deserve another chance. \
I can't quite fix you up completely, but you can't have everything.\n ")
		responses.append(move_to(forest_room))

	# TODO?: Clear trap-door touched
	# TODO: Randomize Objects
	# TODO: Kill timers
	return "\n".join(responses)

func look(force: bool = false) -> String:
	if not get_room().is_lit() and not dead: return "It is pitch black. You are likely to be eaten by a grue."

	return get_room().describe(force)

func _handle_look_while_dead() -> String:
	var responses = ["The room looks strange and unearthly%s." % " and objects appear indistinct" if get_room().has_things() else ""]
	if (not get_room().is_lit()):
		responses.append("Although there is no light, the room seems dimly illuminated.")
	responses.append(" ")
	responses.append(look(true))

	return "\n".join(responses)

func describe_inventory() -> String:
	var things = find_things("", "", false)

	if things.is_empty():
		return "You are empty-handed."

	var responses = ["You are carrying:"]
	const indent_level = 1
	for thing in things:
		if thing is Bag:
			responses.append(thing.describe(indent_level))
			continue

		var article = Vocabulary.get_article(thing.description).capitalize()
		responses.append(indent(indent_level, "%s %s" % [article, thing.description]))

	return "\n".join(responses)

func take(thing: Thing) -> String:
	if not thing.can_be_taken():
		return Vocabulary.get_random_yuk_response()

	if not is_carrying(thing) and get_weight() + thing.weight > LOAD_ALLOWED:
		return "Your load is too heavy%s." % ", especially in light of your condition" if LOAD_ALLOWED < LOAD_MAX else ""

	thing.reparent(self)
	thing.owner = get_node(ROOMS_PATH)
	score += thing.score
	thing.score = 0
	thing.state_flags |= Thing.StateFlags.TOUCHED
	thing.state_flags &= ~Thing.StateFlags.HIDDEN
	return ""

func drop(thing: Thing) -> String:
	if not is_ancestor_of(thing):
		return "You're not carrying the %s." % thing.description

	var room = get_room()
	thing.reparent(room)
	thing.owner = get_node(ROOMS_PATH)
	return ""

func get_weight() -> int:
	# TODO
	return 0

func has_light() -> bool:
	return find_things().any(func(t): return t.is_lit())

func is_carrying(thing: Thing) -> bool:
	return is_ancestor_of(thing)

func move_to(room: Room) -> String:
	reparent(room)
	owner = get_node(ROOMS_PATH)
	room_changed.emit(room)
	score += room.score
	room.score = 0
	var room_description = look()
	if room.is_lit():
		room.flags |= Room.FLAG_VISITED
	return room_description

func move_to_next_room_in_group(group_name: String) -> String:
	var rooms = get_tree().get_nodes_in_group(group_name)
	var index = rooms.find(get_room())
	index = (index + 1) % len(rooms)
	return move_to(rooms[index])

func move(direction: String) -> String:
	var exit = get_room().get_exit(direction)
	if exit == null:
		return "You can't go that way."
	return exit.execute(self)
