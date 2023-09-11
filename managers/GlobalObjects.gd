extends Node

func _ready() -> void:
	var things = find_children("", "Thing", false)
	for thing in things:
		thing.add_to_group("GlobalObjects", true)
