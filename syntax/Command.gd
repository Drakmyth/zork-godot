extends Resource
class_name Command

@export var verb: String
@export var preposition1: String
@export var object1: PackedStringArray
@export var preposition2: String
@export var object2: PackedStringArray

var and_flag = false

func as_string() -> String:
	return " ".join([verb, preposition1, " and ".join(object1), preposition2, " and ".join(object2)].filter(func(x): return not x.is_empty()))

func action() -> String:
	# Implemented by command script
	return ""

func preaction() -> String:
	# Implemented by command script
	return ""

func set_and_flag() -> void:
	and_flag = true

func try_set_preposition(preposition: String) -> bool:
	if preposition1 != "" and preposition2 != "": return false
	if preposition1 == "" and object1.is_empty():
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
