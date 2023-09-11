extends Room

func describe_tokens() -> Array:
	var kitchen_window = get_node("/root/Game/GlobalObjects/KitchenWindow")
	return ["open" if kitchen_window.is_open() else "slightly ajar"]
