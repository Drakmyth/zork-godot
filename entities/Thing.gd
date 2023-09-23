extends GameObject
class_name Thing

enum CapabilityFlags {
	NONE = 0,
	LIGHTWEIGHT = 1,
	ONOFF = 2,
	KINDLING = 4
}

enum StateFlags {
	NONE = 0,
	TOUCHED = 1,
	HIDDEN = 2,
	INVISIBLE = 4,
	LIT = 8,
	FLAMING = 16
}

const DEFAULT_FLOOR_DESC = "There is a %s here."

## Short description of this thing. Primarily used when showing the player's inventory.
@export var description: String
## Description text shown in room descriptions prior to player having picked this thing up (if able to
## do so). Defaults to [member floor_description] if not provided. Override [member _first_description_tokens]
## to provide values for placeholder symbols.
@export_multiline var first_description: String
## Default description text shown in room descriptions. If [member first_description] is provided, this
## will override it when [member FLAG_TOUCHED] is set. Override [member _floor_description_tokens]
## to provide values for placeholder symbols.
@export_placeholder(DEFAULT_FLOOR_DESC) var floor_description: String

## Parser rules. Impacts how this thing is detected and interacted with by the CommandParser.[br]
## [br]
## [b]Lightweight[/b]: Able to be taken by the player.[br]
## [br]
## [b]Touched[/b]: Set automatically after player has taken object at least once. Switches active
## description text from [member first_description] to [member floor_description].[br]
## [br]
## [b]Hide Description[/b]: Prevent this thing from being listed by room descriptions. Useful if the
## room's description already contains text indicating existance of this thing.[br]
## [br]
## [b]Light Source[/b]: This thing emits light.[br]
## [br]
## [b]Flaming[/b]: This thing is on fire. Does not imply [code]Light Source[/code] or
## [code]Kindling[/code].[br]
## [br]
## [b]Kindling[/b]: This thing can be burned.[br]
## [br]
## [b]Invisible[/b]: This object, for all intents and purposes, doesn't exist. Useful for making things
## appear "via magic" or to make things non-interactable when hidden by other things.
@export_flags("Lightweight", "On-Off", "Kindling") var capability_flags: int
@export_flags("Touched", "Hidden", "Invisible", "Lit", "Flaming") var state_flags: int
@export_range(0, 0, 1, "or_greater") var weight: int
@export var score : int = 0
@export var nouns: Array[String] = []
@export var adjectives: Array[String] = []

func _ready() -> void:
	add_to_group(Vocabulary.Groups.OBJECTS, true)

func describe(indent_level: int = 0) -> String:
	if is_hidden():
		return ""

	if not is_touched() and not first_description.is_empty():
		return indent(indent_level, first_description % _first_description_tokens())

	if not floor_description.is_empty():
		return indent(indent_level, floor_description % _floor_description_tokens())

	return indent(indent_level, DEFAULT_FLOOR_DESC % _floor_description_tokens())

func _first_description_tokens() -> Array:
	# Implemented by thing script
	return []

func _floor_description_tokens() -> Array:
	# Implemented by thing script
	return [description] if floor_description.is_empty() else []

func can_be_taken() -> bool:
	return capability_flags & CapabilityFlags.LIGHTWEIGHT

func can_be_onoff() -> bool:
	return capability_flags & CapabilityFlags.ONOFF

func can_be_burned() -> bool:
	return capability_flags & CapabilityFlags.KINDLING

func is_touched() -> bool:
	return state_flags & StateFlags.TOUCHED

func is_hidden() -> bool:
	return state_flags & StateFlags.HIDDEN

func is_invisible() -> bool:
	return state_flags & StateFlags.INVISIBLE

func is_lit() -> bool:
	return state_flags & StateFlags.LIT

func is_flaming() -> bool:
	return state_flags & StateFlags.FLAMING

func is_in_bag() -> bool:
	return get_parent() is Bag

func on_failed_preaction(_command: Command, _player: Player) -> String:
	# Implemented by thing script
	return ""

func action(_command: Command, _player: Player) -> String:
	# Implemented by thing script
	return ""
