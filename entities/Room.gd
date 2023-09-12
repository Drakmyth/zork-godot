extends Node
class_name Room

@export var title: String
@export_multiline var description: String
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
	var descriptions = [title, description % describe_tokens()]
	var thing_descriptions = get_things().map(func(thing): return thing.describe()).filter(func(desc): return not desc.is_empty())
	thing_descriptions.sort()
	descriptions.append_array(thing_descriptions)
	return "\n".join(descriptions)

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

func get_things(noun: String = "", adjective: String = "") -> Array:
	var things = find_children("", "Thing", false)
	things.append_array(get_tree().get_nodes_in_group("GlobalObjects"))
	things.append_array(local_objects.map(func(o): return get_node(o)))

	if not noun.is_empty():
		things = things.filter(func(t): return t.nouns.has(noun))
	if not adjective.is_empty():
		things = things.filter(func(t): return t.adjectives.has(adjective))
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
