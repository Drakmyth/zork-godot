extends Node
class_name Player

signal room_changed

func get_room() -> Room:
	# TODO: Walk up tree in case Player is "inside" something
	return get_parent() as Room

func action(_command: Command, _player: Player) -> String:
	return ""

func get_things(noun: String = "", adjective: String = "") -> Array:
	var things = get_room().get_things(noun, adjective)
	# TODO: also look in inventory
	return things

func take(thing: Thing) -> String:
	return ""

func is_carrying(thing: Thing) -> bool:
	return is_ancestor_of(thing)

func move_to(room: Room) -> String:
	reparent(room)
	room_changed.emit(room)
	return room.describe()

func move_to_next_room_in_group(group_name: String) -> String:
	var rooms = get_tree().get_nodes_in_group(group_name)
	var index = rooms.find(get_room())
	index = (index + 1) % len(rooms)
	return move_to(rooms[index])

func move(direction: String) -> String:
	var exit = get_room().get_exit(direction)
	if exit == null:
		return "You can't go that way."
	return exit.execute(self)
