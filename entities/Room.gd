extends Node
class_name Room

@export var title: String
@export_multiline var description: String

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

func get_things(noun: String = "", adjective: String = "") -> Array:
	var things = find_children("", "Thing", false)
	if not noun.is_empty():
		things = things.filter(func(t): return t.nouns.has(noun))
	if not adjective.is_empty():
		things = things.filter(func(t): return t.adjectives.has(adjective))
	return things

func get_exit(direction: String) -> Exit:
	match direction:
		"north":
			return exit_north
		"east":
			return exit_east
		"south":
			return exit_south
		"west":
			return exit_west
		"northeast":
			return exit_northeast
		"northwest":
			return exit_northwest
		"southeast":
			return exit_southeast
		"southwest":
			return exit_southwest
		"in":
			return exit_in
		"out":
			return exit_out
		"up":
			return exit_up
		"down":
			return exit_down
		"land":
			return exit_land
	return BlockedExit.UnknownDirection()
