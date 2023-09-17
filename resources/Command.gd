extends Resource
class_name Command

# object_flags
const FLAG_TAKE = 1
const FLAG_HOLDING = 2

## The action to be taken. This is the keyword the player must enter to execute this command.
@export var verb: String
## Optional preposition for the direct object.
@export var first_preposition: String
## The maximum number of direct objects this command can process. Set to [param -1] for infinite.
@export_range(-1, 1) var max_direct_objects: int
var direct_objects: Array[Thing]
## Execution flags impart extra requirements on the direct object or execute extra behavior upon
## command execution.[br]
## [br]
## [b]Take[/b]: Attempt to add the item to the player's inventory prior to command execution. If
## the player's inventory is not able to hold the item, the command will be executed regardless.[br]
## [br]
## [b]Holding[/b]: The direct object must be in the player's inventory for the command to succeed.[br]
@export_flags("Take", "Holding") var direct_object_execution_flags: int
## Optional preposition for the indirect object.
@export var second_preposition: String
## The maximum number of indirect objects this command can process. Set to [param -1] for infinite.
@export_range(-1, 1) var max_indirect_objects: int
var indirect_objects: Array[Thing]
## Execution flags impart extra requirements on the indirect object or execute extra behavior upon
## command execution.[br]
## [br]
## [b]Take[/b]: Attempt to add the item to the player's inventory prior to command execution. If
## the player's inventory is not able to hold the item, the command will be executed regardless.[br]
## [br]
## [b]Holding[/b]: The indirect object must be in the player's inventory for the command to succeed.[br]
@export_flags("Take", "Holding") var indirect_object_execution_flags: int

var and_flag := false
var error_response := ""
var prefix := ""

static func ErrorCommand(response: String) -> Command:
	var command = Command.new()
	command.error_response = response
	return command

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

func split_object_commands() -> Array:
	var commands = []
	if len(direct_objects) > 1:
		for do in direct_objects:
			var command = duplicate()
			command.direct_objects = [do] as Array[Thing]
			command.prefix = "%s: " % do.description
			if len(indirect_objects) > 1:
				command.indirect_objects = [indirect_objects[0]]
			commands.append(command)
		return commands

	if len(indirect_objects) > 1:
		for io in indirect_objects:
			var command = duplicate()
			command.indirect_objects = [io] as Array[Thing]
			command.prefix = "%s: " % io.description
			commands.append(command)
		return commands

	return [self]

func get_request_chain(player: Player) -> Array:
	var request_chain = [
		check_holding,
		player.action,
		player.get_room().on_begin_command,
		preaction
	]

	if not indirect_objects.is_empty():
		request_chain.append(indirect_objects[0].action)
	if verb != Vocabulary.Verbs.WALK && not direct_objects.is_empty():
		# container.action
		request_chain.append(direct_objects[0].action)

	request_chain.append(action)
	return request_chain

func try_take(player: Player) -> String:
	if direct_object_execution_flags & FLAG_TAKE:
		if max_direct_objects != 1:
			push_warning("Invalid command configuration for \"%s\" - Max Direct Objects: %d != 1, Take Flag: True" % [as_string(), max_direct_objects])
		if not direct_objects.is_empty() and not player.is_carrying(direct_objects[0]):
			var take_response = player.take(direct_objects[0])
				# TODO: if object not here: "You don't have that!"
				# TODO: if object is here but failed: "You don't have the %s.
			if take_response.is_empty():
				return "(Taken)"

	if indirect_object_execution_flags & FLAG_TAKE:
		if max_indirect_objects != 1:
			push_warning("Invalid command configuration for \"%s\" - Max Indirect Objects: %d != 1, Take Flag: True" % [as_string(), max_indirect_objects])
		if not indirect_objects.is_empty() and not player.is_carrying(indirect_objects[0]):
			var take_response = player.take(indirect_objects[0])
				# TODO: if object not here: "You don't have that!"
				# TODO: if object is here but failed: "You don't have the %s.
			if take_response.is_empty():
				return "(Taken)"

	return ""

static func check_holding(command:Command, player: Player) -> String:
	if command.direct_object_execution_flags & FLAG_HOLDING:
		for do in command.direct_objects:
			if not player.is_carrying(do):
				return "You don't have the %s" % do.description

	if command.indirect_object_execution_flags & FLAG_HOLDING:
		for io in command.indirect_objects:
			if not player.is_carrying(io):
				return "You don't have the %s" % io.description

	return ""

func action(_command: Command, _player: Player) -> String:
	# Implemented by command script
	return ""

func preaction(_command: Command, _player: Player) -> String:
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
