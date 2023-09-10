extends Command

func action() -> String:
	return "Burning %s %s..." % [preposition1, object1[0]]

func preaction() -> String:
	print("Pre-Burning...")
	return ""
