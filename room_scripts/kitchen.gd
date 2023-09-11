extends Room

@export var window_ajar := true

func describe_tokens() -> Array:
	return ["slightly ajar" if window_ajar else "open"]
