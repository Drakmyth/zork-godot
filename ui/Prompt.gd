extends MarginContainer

signal command_submitted

func _ready() -> void:
	$Layout/InputMargin/PromptInput.connect("text_submitted", _on_PromptInput_text_submitted)

	$Layout/InputMargin/PromptInput.grab_focus()

func _on_PromptInput_text_submitted(new_text: String) -> void:
	command_submitted.emit(new_text.strip_edges())
	$Layout/InputMargin/PromptInput.clear()

func set_prompt(prompt: String) -> void:
	$Layout/LabelMargin/PromptLabel.text = prompt

func reset_prompt() -> void:
	$Layout/LabelMargin/PromptLabel.text = ">"
