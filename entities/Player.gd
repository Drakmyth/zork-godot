extends Node
class_name Player

func get_room() -> Room:
	# TODO: Walk up tree in case Player is "inside" something
	return get_parent() as Room

func action() -> String:
	return ""

func get_things(noun: String = "", adjective: String = "") -> Array:
	var things = get_room().get_things(noun, adjective)
	# TODO: also look in inventory
	return things
