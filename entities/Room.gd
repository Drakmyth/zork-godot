extends GameObject
class_name Room

const FLAG_VISITED = 1
const FLAG_LIT = 2

@export var title: String
@export_multiline var description: String
@export_flags("Visited", "Lit") var flags: int
@export var local_objects: Array[NodePath]

@export_group("Exits", "exit_")
@export var exit_north: Exit
@export var exit_east: Exit
@export var exit_south: Exit
@export var exit_west: Exit
@export var exit_northeast: Exit
@export var exit_northwest: Exit
@export var exit_southeast: Exit
@export var exit_southwest: Exit
@export var exit_in: Exit
@export var exit_out: Exit
@export var exit_up: Exit
@export var exit_down: Exit
@export var exit_land: Exit

func describe() -> String:
	var descriptions = [title]
	if not flags & FLAG_VISITED:
		descriptions.append(describe_room())
	descriptions.append(describe_contents())
	return "\n".join(descriptions)

func describe_room() -> String:
	return description % describe_tokens()

func describe_contents() -> String:
	var things = find_things("", "", false)
	var thing_descriptions = things.map(func(t): return t.describe()).filter(func(desc): return not desc.is_empty())
	thing_descriptions.sort()
	return "\n".join(thing_descriptions)

func describe_tokens() -> Array:
	# Implemented by room script
	return []

func on_enter() -> void:
	# Implemented by room script
	pass

func on_begin_command(_command: Command, _player: Player) -> String:
	# Implemented by room script
	return ""

func on_end_command(_command: Command, _player: Player) -> String:
	# Implemented by room script
	return ""

func get_local_object(object_name: String) -> Thing:
	for object_path in local_objects:
		var object = get_node(object_path)
		if object.name == object_name: return object
	return null

func find_things(noun: String = "", adjective: String = "", recursive: bool = true) -> Array:
	var things = super(noun, adjective, recursive)
	var other_things = get_tree().get_nodes_in_group("GlobalObjects")
	other_things.append_array(local_objects.map(func(o): return get_node(o)))

	if not noun.is_empty():
		other_things = other_things.filter(func(t): return t.nouns.has(noun))
	if not adjective.is_empty():
		other_things = other_things.filter(func(t): return t.adjectives.has(adjective))

	things.append_array(other_things)
	return things

func get_exit(direction: String) -> Exit:
	match direction:
		Vocabulary.Directions.NORTH:
			return exit_north
		Vocabulary.Directions.EAST:
			return exit_east
		Vocabulary.Directions.SOUTH:
			return exit_south
		Vocabulary.Directions.WEST:
			return exit_west
		Vocabulary.Directions.NORTHEAST:
			return exit_northeast
		Vocabulary.Directions.NORTHWEST:
			return exit_northwest
		Vocabulary.Directions.SOUTHEAST:
			return exit_southeast
		Vocabulary.Directions.SOUTHWEST:
			return exit_southwest
		Vocabulary.Directions.IN:
			return exit_in
		Vocabulary.Directions.OUT:
			return exit_out
		Vocabulary.Directions.UP:
			return exit_up
		Vocabulary.Directions.DOWN:
			return exit_down
		Vocabulary.Directions.LAND:
			return exit_land
	return BlockedExit.UnknownDirection()
