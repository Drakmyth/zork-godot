extends Exit
class_name FunctionExit

@export var function_name: String

func execute(_player: Player) -> String:
	return "You can't go this way... yet!"
