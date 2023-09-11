extends Room

@export var cyclops_hole := false
@export var rug_moved := false
@export var trap_door_open := false

func describe_tokens() -> Array:
	var doorway_token = ". To the west is a cyclops-shaped opening in an old wooden door, above which is some strange gothic lettering" \
		if cyclops_hole else ", a wooden door with strange gothic lettering to the west, which appears to be nailed shut"

	var floor_token = ""
	if rug_moved and trap_door_open:
		floor_token = "and a rug lying beside an open trap door"
	elif rug_moved:
		floor_token = "and a closed trap door at your feet"
	elif trap_door_open:
		floor_token = "and an open trap door at your feet"
	else:
		floor_token = "and a large oriental rug in the center of the room"

	return [doorway_token, floor_token]
