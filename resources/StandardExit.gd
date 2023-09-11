extends Exit
class_name StandardExit

@export_node_path("Room") var destination: NodePath

func execute(player: Player) -> String:
	var room = player.get_room()
	return player.move_to(room.get_node(destination))
