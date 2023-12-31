extends MarginContainer

signal command_submitted

func _ready() -> void:
	$Layout/InputMargin/PromptInput.connect("text_submitted", _on_PromptInput_text_submitted)
	focus()

func _on_PromptInput_text_submitted(new_text: String) -> void:
	command_submitted.emit(new_text.strip_edges())

func clear() -> void:
	$Layout/InputMargin/PromptInput.clear()

func focus() -> void:
	$Layout/InputMargin/PromptInput.grab_focus()
