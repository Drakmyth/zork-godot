extends Thing

@export var broken: bool = false

func _ready() -> void:
	super()
	connect("state_changed", _on_state_changed)

func action(command: Command, _player: Player) -> String:
	match command.verb:
		Vocabulary.Verbs.THROW:
			_break()
			return "The lamp has smashed into the floor, and the light has gone out."
		Vocabulary.Verbs.ACTIVATE:
			if is_broken(): return "A burned-out lamp won't light."
			# TODO: Start lamp fuel timer
			return ""
		Vocabulary.Verbs.BLOW:
			if is_broken(): return "The lamp has already burned out."
			# TODO: Stop lamp fuel timer
			return ""

	return ""

func is_broken() -> bool:
	return broken

func _break() -> void:
	broken = true
	state_flags &= ~Thing.StateFlags.ACTIVATED
	state_flags &= ~Thing.StateFlags.LIT
	description = "broken lantern"
	first_description = ""
	floor_description = ""
	capability_flags &= ~Thing.CapabilityFlags.ONOFF
	nouns.erase("light")
	adjectives.erase("brass")
	adjectives.append("broken")

func examine() -> String:
	if is_broken(): return "The %s has burned out." % description
	if is_activated(): return "The %s is on." % description
	return "The %s is turned off." % description

func _on_state_changed(_new_state_flags: int, old_state_flags: int) -> void:
	var was_activated = old_state_flags & Thing.StateFlags.ACTIVATED
	if is_activated() and not was_activated:
		state_flags |= Thing.StateFlags.LIT
	elif was_activated and not is_activated():
		state_flags &= ~Thing.StateFlags.LIT
