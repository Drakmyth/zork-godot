extends ScrollContainer

const ResponseNodeScene = preload("res://ui/Response.tscn")

func add_response(input: String, response: String):
	if response.is_empty(): return

	var response_node = ResponseNodeScene.instantiate()
	response_node.input = input
	response_node.response = response
	$Layout.add_child(response_node)
	response_node.owner = self
	await get_tree().process_frame
	ensure_control_visible(response_node)

func scroll_to_bottom():
	var last_child = $Layout.get_child(-1)
	ensure_control_visible(last_child)
