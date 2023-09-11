extends Room

func describe_tokens() -> Array:
	return ["open" if get_local_object("KitchenWindow").is_open() else "slightly ajar"]
