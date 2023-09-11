extends Resource
class_name Command

const FLAG_ALLOW_MULTIPLE = 1

@export var verb: String
@export var first_preposition: String
@export_range(-1, 1) var max_direct_objects: int
var direct_objects: Array[Thing]
@export_flags("Multiple") var direct_object_flags: int
@export var second_preposition: String
@export_range(-1, 1) var max_indirect_objects: int
var indirect_objects: Array[Thing]
@export_flags("Multiple") var indirect_object_flags: int

var and_flag := false
var error_response := ""

func as_string() -> String:
	return " ".join([
		verb,
		first_preposition,
		" and ".join(direct_objects.map(func(d): return d.description)),
		second_preposition,
		" and ".join(indirect_objects.map(func(i): return i.description))
	].filter(func(i): return not i.is_empty()))

func populate_from(command: Command) -> Command:
	verb = command.verb
	first_preposition = command.first_preposition
	direct_objects = command.direct_objects
	second_preposition = command.second_preposition
	indirect_objects = command.indirect_objects

	if (max_direct_objects == 0 and len(direct_objects) > 0) \
		or (max_indirect_objects == 0 and len(indirect_objects) > 0):
		error_response = "There were too many nouns in that sentence."
	elif max_direct_objects == 1 and len(direct_objects) > 1:
		error_response = "You can't use multiple direct objects with \"%s\"" % verb
	elif max_indirect_objects == 1 and len(indirect_objects) > 1:
		error_response = "You can't use multiple indirect objects with \"%s\"" % verb

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
	if not first_preposition.is_empty() and not second_preposition.is_empty(): return false
	if first_preposition.is_empty() and direct_objects.is_empty():
		first_preposition = preposition
	else:
		second_preposition = preposition
	return true

func try_set_object(object: Thing) -> bool:
	if not direct_objects.is_empty() and not indirect_objects.is_empty() and not and_flag: return false

	if not indirect_objects.is_empty() and and_flag:
		indirect_objects.append(object)
	elif not direct_objects.is_empty() and and_flag:
		direct_objects.append(object)
	elif direct_objects.is_empty():
		if and_flag:
			push_warning("'and_flag' set but no objects to append to. Ignoring...")
		direct_objects.append(object)
	else:
		indirect_objects.append(object)

	and_flag = false
	return true
