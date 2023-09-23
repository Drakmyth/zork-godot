extends Node
class_name GameObject

const INDENT = "  "

func find_things(noun: String = "", adjective: String = "", recursive: bool = true) -> Array:
	var things = get_children().filter(func(c): return c is Thing and not c.is_invisible())

	if recursive:
		var child_things = []
		for thing in things:
			child_things.append_array(thing.find_things(noun, adjective, recursive))
		things.append_array(child_things)

	if not noun.is_empty():
		things = things.filter(func(t): return t.nouns.has(noun))
	if not adjective.is_empty():
		things = things.filter(func(t): return t.adjectives.has(adjective))

	return things

func indent(indent_level: int, message: String) -> String:
	return message.indent(INDENT.repeat(indent_level))
