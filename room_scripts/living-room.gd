extends Room

@export var cyclops_hole := false
@export_node_path("Thing") var rug: NodePath
@export_node_path("Door") var trap_door: NodePath

func _describe_tokens() -> Array:
	var rug_obj = get_node(rug) as Thing
	var td_obj = get_node(trap_door) as Door

	var doorway_token = ". To the west is a cyclops-shaped opening in an old wooden door, above which is some strange gothic lettering" \
		if cyclops_hole else ", a wooden door with strange gothic lettering to the west, which appears to be nailed shut"

	var floor_token = ""
	if rug_obj.moved and td_obj.is_open():
		floor_token = "and a rug lying beside an open trap door"
	elif rug_obj.moved:
		floor_token = "and a closed trap door at your feet"
	elif td_obj.is_open():
		floor_token = "and an open trap door at your feet"
	else:
		floor_token = "and a large oriental rug in the center of the room"

	return [doorway_token, floor_token]
