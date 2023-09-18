extends Thing
class_name Stairs

@export var leads_up: bool

func action(_command: Command, _player: Player) -> String:
	# TODO: "You should say whether you want to go up or down."
	return ""
