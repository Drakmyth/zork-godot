extends Room

func _describe_tokens() -> Array:
	return ["open" if get_local_object("kitchen-window").is_open() else "slightly ajar"]
