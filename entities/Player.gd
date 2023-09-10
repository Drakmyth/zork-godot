extends Node
class_name Player

func get_room() -> Room:
	# TODO: Walk up tree in case Player is "inside" something
	return get_parent() as Room

func is_known_adjective(word: String) -> bool:
	var room = get_room()
	var things = room.get_things() as Array[Thing]
	# TODO: cache things and regenerate cache on room change
	for thing in get_room().get_things() as Array[Thing]:
		if thing.adjectives.has(word): return true
	return false

func is_known_object(word: String) -> bool:
	var room = get_room()
	var things = room.get_things() as Array[Thing]
	# TODO: cache things and regenerate cache on room change
	for thing in things:
		if thing.title == word: return true
		if thing.synonyms.has(word): return true
	return false
