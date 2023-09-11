extends Node
class_name Room

@export var title: String
@export_multiline var description: String
@export_node_path("Room") var north: NodePath
@export_node_path("Room") var east: NodePath
@export_node_path("Room") var south: NodePath
@export_node_path("Room") var west: NodePath
@export_node_path("Room") var northeast: NodePath
@export_node_path("Room") var northwest: NodePath
@export_node_path("Room") var southeast: NodePath
@export_node_path("Room") var southwest: NodePath
@export_node_path("Room") var up: NodePath
@export_node_path("Room") var down: NodePath

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
