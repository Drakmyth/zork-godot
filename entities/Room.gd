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
	return "%s\n%s" % [title, description] % describe_tokens()

func describe_tokens() -> Array[String]:
	# Implemented by room script
	return []

func on_enter() -> void:
	# Implemented by room script
	pass

func on_begin_command() -> String:
	# Implemented by room script
	return ""

func on_end_command() -> String:
	# Implemented by room script
	return ""

func get_things() -> Array:
	return find_children("", "Thing", false)
