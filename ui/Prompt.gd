extends HBoxContainer

signal command_submitted

func _ready() -> void:
	$PromptInput.connect("text_submitted", _on_PromptInput_text_submitted)
	
	$PromptInput.grab_focus()

func _on_PromptInput_text_submitted(new_text: String) -> void:
	command_submitted.emit(new_text)
	$PromptInput.clear()