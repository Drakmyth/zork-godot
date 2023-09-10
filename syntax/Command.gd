extends Resource
class_name Command

@export var verb: String
@export var preposition1: String
@export var object1: PackedStringArray
@export var preposition2: String
@export var object2: PackedStringArray

var and_flag := false
var error_response := ""

func as_string() -> String:
	return " ".join([verb, preposition1, " and ".join(object1), preposition2, " and ".join(object2)].filter(func(x): return not x.is_empty()))

func populate_from(command: Command) -> Command:
	verb = command.verb
	preposition1 = command.preposition1
	object1 = command.object1
	preposition2 = command.preposition2
	object2 = command.object2
	return self

func action() -> String:
	# Implemented by command script
	return ""

func preaction() -> String:
	# Implemented by command script
	return ""

func set_and_flag() -> void:
	and_flag = true

func try_set_preposition(preposition: String) -> bool:
	if not preposition1.is_empty() and not preposition2.is_empty(): return false
	if preposition1.is_empty() and object1.is_empty():
		preposition1 = preposition
	else:
		preposition2 = preposition
	return true

func try_set_object(object: String) -> bool:
	if not object1.is_empty() and not object2.is_empty() and not and_flag: return false

	if not object2.is_empty() and and_flag:
		object2.append(object)
	elif not object1.is_empty() and and_flag:
		object1.append(object)
	elif object1.is_empty():
		if and_flag:
			push_warning("'and_flag' set but no objects to append to. Ignoring...")
		object1.append(object)
	else:
		object2.append(object)

	and_flag = false
	return true
