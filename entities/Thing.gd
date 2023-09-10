extends Node
class_name Thing

@export var title: String
@export_multiline var description: String
@export var synonyms: Array[String] = []
@export var adjectives: Array[String] = []

func describe() -> String:
	return description

func action() -> String:
	return ""
