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
