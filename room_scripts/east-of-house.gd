extends Room

@export var window_ajar := true

func describe() -> String:
	return description % ("slightly ajar" if window_ajar else "open")
