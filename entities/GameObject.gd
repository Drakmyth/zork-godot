extends Node
class_name GameObject

func find_things(noun: String = "", adjective: String = "", recursive: bool = true) -> Array:
	var things = get_children().filter(func(c): return c is Thing and not c.parser_flags & Thing.FLAG_INVISIBLE)
	
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
