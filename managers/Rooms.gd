extends Node

func _ready() -> void:
	var objects = find_children("*", "GameObject", true, false)
	for object in objects:
		object.owner = self
