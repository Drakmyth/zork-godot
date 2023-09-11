# meta-default: true
extends Thing

func _first_description_tokens() -> Array:
	return []

func _floor_description_tokens() -> Array:
	return [description] if floor_description.is_empty() else []

func action(_command: Command, _player: Player) -> String:
	return ""
