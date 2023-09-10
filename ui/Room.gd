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

func action() -> void:
	# Implemented by room script
	pass
