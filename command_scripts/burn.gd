extends Command

func action() -> String:
	return "Burning %s %s..." % [first_preposition, direct_objects[0].description]

func preaction() -> String:
	print("Pre-Burning...")
	return ""
