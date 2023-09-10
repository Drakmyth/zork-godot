extends ScrollContainer

const ResponseNodeScene = preload("res://ui/Response.tscn")

func add_response(input: String, response: String):
	var response_node = ResponseNodeScene.instantiate()
	response_node.input = input
	response_node.response = response
	$Layout.add_child(response_node)
