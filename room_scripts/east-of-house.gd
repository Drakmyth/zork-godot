extends Room

func _describe_tokens() -> Array:
	return ["open" if get_node("kitchen-window").is_open() else "slightly ajar"]
