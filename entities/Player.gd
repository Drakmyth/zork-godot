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

func action(_command: Command, _player: Player) -> String:
	return ""

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
	var room_description = room.describe()
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
