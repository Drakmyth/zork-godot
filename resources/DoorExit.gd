extends Exit
class_name DoorExit

const DEFAULT_CLOSED_RESPONSE = "The %s is closed."

@export_node_path("Door") var door: NodePath
@export_placeholder(DEFAULT_CLOSED_RESPONSE) var closed_response: String
@export_node_path("Room") var destination: NodePath

func execute(player: Player) -> String:
	if can_exit(player):
		# get_node needs to be called relative to room
		return player.move_to(player.get_room().get_node(destination))

	return closed_response if not closed_response.is_empty() else DEFAULT_CLOSED_RESPONSE % player.get_room().get_node(door).description

func can_exit(player: Player) -> bool:
	return player.get_room().get_node(door).is_open()
