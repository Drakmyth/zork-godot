# meta-default: true
extends Room

func describe_tokens() -> Array:
	return []

func on_enter() -> void:
	pass

func on_begin_command(_command: Command, _player: Player) -> String:
	return ""

func on_end_command(_command: Command, _player: Player) -> String:
	return ""
