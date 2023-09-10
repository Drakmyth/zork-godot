extends Node
class_name Thing

const FLAG_TOUCHED = 1 # Set after player has taken object at least once
const FLAG_HIDE_DESCRIPTION = 2 # Prevents item from describing itself

const DEFAULT_FLOOR_DESC = "There is a %s here."

@export_flags("Touched", "Hide Description") var flags: int
@export var description: String
@export var first_description: String
@export_placeholder(DEFAULT_FLOOR_DESC) var floor_description: String
@export var nouns: Array[String] = []
@export var adjectives: Array[String] = []

func describe() -> String:
	if flags & FLAG_HIDE_DESCRIPTION:
		return ""

	if flags & FLAG_TOUCHED or first_description.is_empty():
		if floor_description.is_empty():
			return DEFAULT_FLOOR_DESC % floor_description_tokens()
		else:
			return floor_description % floor_description_tokens()

	return first_description % first_description_tokens()

func first_description_tokens() -> Array:
	return []

func floor_description_tokens() -> Array:
	return [description] if floor_description.is_empty() else []

func action() -> String:
	return ""
