extends Room

@export var window_ajar := true

func describe_tokens() -> Array[String]:
	return ["slightly ajar" if window_ajar else "open"]
