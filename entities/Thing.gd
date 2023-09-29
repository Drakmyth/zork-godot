extends GameObject
class_name Thing

enum CapabilityFlags {
	NONE = 0,
	LIGHTWEIGHT = 1,
	ONOFF = 2,
	KINDLING = 4,
	WRITTEN = 8
}

enum StateFlags {
	NONE = 0,
	TOUCHED = 1,
	HIDDEN = 2,
	INVISIBLE = 4,
	TRANSPARENT = 8,
	ACTIVATED = 16,
	LIT = 32,
	FLAMING = 64
}

const DEFAULT_FLOOR_DESC = "There is a %s here."
const DEFAULT_EXAMINE_DESC = "There's nothing special about the %s."

signal state_changed

## Short description of this thing. Primarily used when showing the player's inventory.
@export var description: String

## Description text shown in room descriptions prior to player having picked this thing up (if able to
## do so). Defaults to [member floor_description] if not provided. Override [method _first_description_tokens]
## to provide values for placeholder symbols.
@export_multiline var first_description: String

## Default description text shown in room descriptions. If [member first_description] is provided, this
## will override it when [member StateFlags.TOUCHED] is set. Override [method _floor_description_tokens]
## to provide values for placeholder symbols.
@export_placeholder(DEFAULT_FLOOR_DESC) var floor_description: String

## Description shown in response to [code]EXAMINE[/code] and/or [code]READ[/code] commands. Override
## [method _examine_description_tokens] to provide values for placeholder symbols. Defaults to
## "There's nothing special about the %s." if not provided.
@export_multiline var examine_description: String

## Capabilities define what this thing "can do" or "can be". Primarily used to determine what
## commands can interact with this thing.[br]
## [br]
## [b]Lightweight[/b]: Can be taken.[br]
## [br]
## [b]On-Off[/b]: Can be turned on/off or activated.[br]
## [br]
## [b]Kindling[/b]: Can be burned.[br]
## [br]
## [b]Written[/b]: Can be read.[br]
@export_flags("Lightweight", "On-Off", "Kindling", "Written") var capability_flags: int

## State defines what this thing "is" or "is doing". Represents properties of the object itself.[br]
## [br]
## [b]Touched[/b]: Set automatically after the player has taken this thing at least once. Changes
## active description text from [member first_description] to [member floor_description].[br]
## [br]
## [b]Hidden[/b]: This thing will not be listed by room descriptions. Useful if the
## room's description already contains text indicating existence of this thing.[br]
## [br]
## [b]Invisible[/b]: This thing, for all intents and purposes, doesn't exist. Useful for making things
## appear "via magic" or to make things non-interactable when obscured by other things.[br]
## [br]
## [b]Transparent[/b]: This thing can be seen through. If it is a [Bag], it's contents can be seen
## even while closed.[br]
## [br]
## [b]Activated[/b]: This thing is turned on. Does not imply [code]Lit[/code].[br]
## [br]
## [b]Lit[/b]: This thing is emitting light. Does not imply [code]Activated[/code].[br]
## [br]
## [b]Flaming[/b]: This thing is on fire or is otherwise capable of burning other objects. Does not
## imply [code]Lit[/code] or the [code]Kindling[/code] capability.[br]
@export_flags("Touched", "Hidden", "Invisible", "Transparent", "Activated", "Lit", "Flaming") var state_flags: int : set = _on_state_flags_set
@export_range(0, 0, 1, "or_greater") var weight: int
@export var score : int = 0
@export var nouns: Array[String] = []
@export var adjectives: Array[String] = []

func _ready() -> void:
	add_to_group(Vocabulary.Groups.OBJECTS, true)

func describe(indent_level: int = 0) -> String:
	if is_hidden(): return ""

	if not is_touched() and not first_description.is_empty():
		return indent(indent_level, first_description % _first_description_tokens())

	if not floor_description.is_empty():
		return indent(indent_level, floor_description % _floor_description_tokens())

	return indent(indent_level, DEFAULT_FLOOR_DESC % _floor_description_tokens())

func examine() -> String:
	var ex_desc = examine_description if not examine_description.is_empty() else DEFAULT_EXAMINE_DESC
	return ex_desc % _examine_description_tokens()

func read() -> String:
	if not can_be_read(): return "How does one read a %s?" % description

	var ex_desc = examine_description if not examine_description.is_empty() else DEFAULT_EXAMINE_DESC
	return ex_desc % _examine_description_tokens()

func _on_state_flags_set(new_state_flags: int) -> void:
	var old_state_flags = state_flags
	state_flags = new_state_flags
	state_changed.emit(new_state_flags, old_state_flags)

func _first_description_tokens() -> Array:
	# Implemented by thing script
	return []

func _floor_description_tokens() -> Array:
	# Implemented by thing script
	return [description] if floor_description.is_empty() else []

func _examine_description_tokens() -> Array:
	# Implemented by thing script
	return [description] if examine_description.is_empty() else []

func can_be_taken() -> bool:
	return capability_flags & CapabilityFlags.LIGHTWEIGHT

func can_be_onoff() -> bool:
	return capability_flags & CapabilityFlags.ONOFF

func can_be_burned() -> bool:
	return capability_flags & CapabilityFlags.KINDLING

func can_be_read() -> bool:
	return capability_flags & CapabilityFlags.WRITTEN

func is_touched() -> bool:
	return state_flags & StateFlags.TOUCHED

func is_hidden() -> bool:
	return state_flags & StateFlags.HIDDEN

func is_invisible() -> bool:
	return state_flags & StateFlags.INVISIBLE

func is_transparent() -> bool:
	return state_flags & StateFlags.TRANSPARENT

func is_activated() -> bool:
	return state_flags & StateFlags.ACTIVATED

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
