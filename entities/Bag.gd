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

func is_open() -> bool:
	return open

func find_things(noun: String = "", adjective: String = "", recursive: bool = true) -> Array:
	return super(noun, adjective, recursive) if open or behavior_flags & FLAG_TRANSPARENT else []

func contains_thing_by_name(thing_name: String) -> bool:
	return find_child(thing_name) != null

func list_contents() -> String:
	var contents = find_things()
	var descriptions = contents.map(func (c): return "a %s" % c.description)
	if len(contents) > 1:
		descriptions[-1] = "and %s" % descriptions[-1]
	return ", ".join(descriptions)
