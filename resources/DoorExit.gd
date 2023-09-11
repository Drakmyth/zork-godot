extends Exit
class_name DoorExit

const DEFAULT_CLOSED_RESPONSE = "The %s is closed."

@export_node_path("Door") var door: NodePath
@export_placeholder(DEFAULT_CLOSED_RESPONSE) var closed_response: String
@export_node_path("Room") var destination: NodePath

func execute(player: Player) -> String:
	var room = player.get_room()
	var door_obj = room.get_node(door) as Door
	if door_obj.is_open():
		return player.move_to(room.get_node(destination))

	return closed_response if not closed_response.is_empty() else DEFAULT_CLOSED_RESPONSE % door_obj.description
