extends Thing
class_name Bag

# behavior_flags
const FLAG_SURFACE = 1
const FLAG_TRANSPARENT = 2

@export var open = false
@export_range(0, 100, 1, "or_greater") var capacity: int = 50
## Behavior rules. Impacts how this thing is described or behaves.[br]
## [br]
## [b]Surface[/b]: Indicates descriptions should read more like a table or countertop rather than a
## bag or box. In particular, things are placed [i]ON[/i] this instead of [i]IN[/i] it.[br]
## [br]
## [b]Transparent[/b]: Things inside this bag are visible to the player even when it is closed.[br]
@export_flags("Surface", "Transparent") var behavior_flags: int

func describe(indent_level: int = 0) -> String:
	var responses = []
	var contents = find_things("", "", false)

	var first_things = contents.filter(func(c): return not c.is_touched() and not c.first_description.is_empty() and not c.is_hidden())
	for thing in first_things:
		responses.append(indent(indent_level, thing.describe()))
		contents.erase(thing)

	if not is_hidden():
		if indent_level == 0:
			responses.append(super(indent_level))
		else:
			var self_article = Vocabulary.get_article(description).capitalize()
			responses.append(indent(indent_level, "%s %s" % [self_article, description]))

	if not can_see_inside() or contents.is_empty():
		return "\n".join(responses)

	if is_surface():
		responses.append(indent(indent_level, "Sitting on the %s is:" % description))
	else:
		responses.append(indent(indent_level, "The %s contains:" % description))

	for thing in contents:
		if thing is Bag:
			responses.append(thing.describe(indent_level + 1))
			continue

		var article = Vocabulary.get_article(thing.description).capitalize()
		responses.append(indent(indent_level + 1, "%s %s" % [article, thing.description]))

	return "\n".join(responses)

func is_open() -> bool:
	return open

func is_surface() -> bool:
	return behavior_flags & FLAG_SURFACE

func can_see_inside() -> bool:
	return is_open() or behavior_flags & FLAG_TRANSPARENT

func find_things(noun: String = "", adjective: String = "", recursive: bool = true) -> Array:
	return super(noun, adjective, recursive) if open or behavior_flags & FLAG_TRANSPARENT else []

func contains_thing_by_name(thing_name: String) -> bool:
	return find_child(thing_name) != null

func list_contents() -> String:
	var contents = find_things("", "", false)
	var descriptions = contents.map(func (c): return "a %s" % c.description)
	if len(contents) > 1:
		descriptions[-1] = "and %s" % descriptions[-1]
	return ", ".join(descriptions)
