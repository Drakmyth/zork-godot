extends Exit
class_name BlockedExit

@export var response: String

static func UnknownDirection():
	var exit = BlockedExit.new()
	exit.response = "You should supply a direction!"
	return exit

func execute(_player: Player) -> String:
	return response
