extends Node

const GLOBALOBJECTS_PATH = NodePath("/root/Game/GlobalObjects")
const ROOMS_PATH = NodePath("/root/Game/Rooms")
const RESPONSEHISTORY_PATH = NodePath("/root/Game/Interface/Margin/Layout/ResponseHistory")

func save() -> void:
	var rooms = get_node(ROOMS_PATH)
	_pack_and_save(rooms, "user://slot1_rooms.tscn")

	var global_objects = get_node(GLOBALOBJECTS_PATH)
	_pack_and_save(global_objects, "user://slot1_globalobjects.tscn")

	var response_history = get_node(RESPONSEHISTORY_PATH)
	_pack_and_save(response_history, "user://slot1_responsehistory.tscn")

func restore() -> void:
	var rooms = get_node(ROOMS_PATH)
	rooms = _restore_packed(rooms, "user://slot1_rooms.tscn")

	var global_objects = get_node(GLOBALOBJECTS_PATH)
	global_objects = _restore_packed(global_objects, "user://slot1_globalobjects.tscn")

	var response_history = get_node(RESPONSEHISTORY_PATH)
	response_history = _restore_packed(response_history, "user://slot1_responsehistory.tscn")

	await get_tree().process_frame

	var game = get_node("/root/Game")
	game.initialize()
	game.history = get_node(RESPONSEHISTORY_PATH)
	game.history.scroll_to_bottom()

func _pack_and_save(node: Node, path: String) -> void:
	var scene = PackedScene.new()
	var result = scene.pack(node)
	if result == OK:
		var error = ResourceSaver.save(scene, path)
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")

func _restore_packed(node: Node, path: String) -> Node:
	node.name += "_old"
	var scene = load(path)
	var new_node = scene.instantiate()
	node.add_sibling(new_node)
	node.queue_free()
	return new_node
