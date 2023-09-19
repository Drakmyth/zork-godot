extends GameObject
class_name Thing

# parser_flags
const FLAG_LIGHTWEIGHT = 1
const FLAG_TOUCHED = 2
const FLAG_HIDE_DESCRIPTION = 4
const FLAG_LIGHT_SOURCE = 8
const FLAG_FLAMING = 16
const FLAG_KINDLING = 32
const FLAG_INVISIBLE = 64

const DEFAULT_FLOOR_DESC = "There is a %s here."

## Short description of this thing. Primarily used when showing the player's inventory.
@export var description: String
## Description text shown in room descriptions prior to player having picked this thing up (if able to
## do so). Defaults to [member floor_description] if not provided. Override [member _first_description_tokens]
## to provide values for placeholder symbols.
@export var first_description: String
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
@export_flags("Lightweight", "Touched", "Hide Description", "Light Source", "Flaming", "Kindling", "Invisible") var parser_flags: int
@export_range(0, 0, 1, "or_greater") var weight: int
@export var nouns: Array[String] = []
@export var adjectives: Array[String] = []

func _ready() -> void:
	add_to_group(Vocabulary.Groups.OBJECTS)

func describe(indent_level: int = 0) -> String:
	if is_hiding_description():
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

func is_hiding_description() -> bool:
	return parser_flags & FLAG_HIDE_DESCRIPTION

func is_touched() -> bool:
	return parser_flags & FLAG_TOUCHED

func is_in_bag() -> bool:
	return get_parent() is Bag

func is_lit() -> bool:
	return parser_flags & FLAG_LIGHT_SOURCE

func on_failed_preaction(_command: Command, _player: Player) -> String:
	# Implemented by thing script
	return ""

func action(_command: Command, _player: Player) -> String:
	# Implemented by thing script
	return ""
