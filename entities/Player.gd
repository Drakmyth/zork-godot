extends Node
class_name Player

func get_room() -> Room:
	# TODO: Walk up tree in case Player is "inside" something
	return get_parent() as Room
