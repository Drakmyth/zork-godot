extends MarginContainer

signal command_submitted

func _ready() -> void:
	$Layout/PromptInput.connect("text_submitted", _on_PromptInput_text_submitted)
	
	$Layout/PromptInput.grab_focus()

func _on_PromptInput_text_submitted(new_text: String) -> void:
	command_submitted.emit(new_text.strip_edges())
	$Layout/PromptInput.clear()
