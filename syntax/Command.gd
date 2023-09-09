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

func try_set_preposition(preposition: String) -> bool:
	if preposition1 != "" and preposition2 != "": return false
	if preposition1 == "" and object1 == "":
		preposition1 = preposition
	else:
		preposition2 = preposition
	return true

func try_set_object(object: String) -> bool:
	if object1 != "" and object2 != "": return false
	if object1 == "":
		object1 = object
	else:
		object2 = object
	return true
