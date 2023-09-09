extends Resource
class_name Command

@export var verb: String
@export var preposition1: String
@export var object1: String
@export var preposition2: String
@export var object2: String
@export var action: String
@export var preaction: String

func as_phrase() -> String:
	return " ".join([verb, preposition1, object1, preposition2, object2].filter(func(x): return not x.is_empty()))

func execute() -> void:
	if not preaction.is_empty():
		CommandFunctions.call(preaction)
	CommandFunctions.call(action)
