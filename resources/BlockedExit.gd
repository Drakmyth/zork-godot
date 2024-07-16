extends Exit
class_name BlockedExit

@export var response: String

static func UnknownDirection():
	var exit = BlockedExit.new()
	exit.response = "You should supply a direction!"
	return exit

static func UnknownDoor():
	var exit = BlockedExit.new()
	exit.response = "That entrance doesn't seem to be here!"
	return exit

func execute(_player: Player) -> String:
	return response

func can_exit(_player: Player) -> bool:
	return false
