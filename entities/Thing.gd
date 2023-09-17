extends Node
class_name Thing

# parser_flags
const FLAG_LIGHTWEIGHT = 1
const FLAG_TOUCHED = 2
const FLAG_HIDE_DESCRIPTION = 4
const FLAG_LIGHT_SOURCE = 8
const FLAG_FLAMING = 16

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
## [b]Flaming[/b]: This thing is on fire. Does not imply [code]Light Source[/code]
@export_flags("Lightweight", "Touched", "Hide Description", "Light Source", "Flaming") var parser_flags: int
@export_range(0, 0, 1, "or_greater") var weight: int
@export var nouns: Array[String] = []
@export var adjectives: Array[String] = []

func _ready() -> void:
	add_to_group(Vocabulary.Groups.OBJECTS)

func describe() -> String:
	if parser_flags & FLAG_HIDE_DESCRIPTION:
		return ""

	if parser_flags & FLAG_TOUCHED or first_description.is_empty():
		if floor_description.is_empty():
			return DEFAULT_FLOOR_DESC % _floor_description_tokens()
		else:
			return floor_description % _floor_description_tokens()

	return first_description % _first_description_tokens()

func _first_description_tokens() -> Array:
	# Implemented by thing script
	return []

func _floor_description_tokens() -> Array:
	# Implemented by thing script
	return [description] if floor_description.is_empty() else []

func is_in_bag() -> bool:
	return get_parent() is Bag

func on_failed_preaction(_command: Command, _player: Player) -> String:
	# Implemented by thing script
	return ""

func action(_command: Command, _player: Player) -> String:
	# Implemented by thing script
	return ""
