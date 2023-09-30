extends Node

const confirmDialogPath = NodePath("/root/Game/Dialog/ConfirmDialog")
const promptPath = NodePath("/root/Game/Interface/Margin/Layout/Prompt")

func _show_choice_dialog(message: String, choice: bool):
	var confirmDialog = get_node(confirmDialogPath)
	var prompt = get_node(promptPath)

	confirmDialog.set_choice_mode(choice)
	confirmDialog.message = message
	confirmDialog.visible = true
	confirmDialog.focus()
	var confirmed = await confirmDialog.confirmation_received
	confirmDialog.visible = false
	prompt.focus()

	return confirmed

func confirm(message: String) -> bool:
	return await _show_choice_dialog(message, true)

func quit(message: String) -> bool:
	return await _show_choice_dialog(message, false)
