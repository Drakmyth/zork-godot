extends Thing
class_name Door

@export var open = false

func is_open() -> bool:
	return open

func examine() -> String:
	var ex_desc = "The %s is open, but I can't tell what's beyond it." if open else "The %s is closed."
	return ex_desc % description
