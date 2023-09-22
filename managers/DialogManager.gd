extends Node

const confirmDialogPath = NodePath("/root/Game/Dialog/ConfirmDialog")
const promptPath = NodePath("/root/Game/Interface/Margin/Layout/Prompt")

func confirm(message: String) -> bool:
	var confirmDialog = get_node(confirmDialogPath)
	var prompt = get_node(promptPath)

	confirmDialog.message = message
	confirmDialog.visible = true
	confirmDialog.focus()
	var confirmed = await confirmDialog.confirmation_received
	confirmDialog.visible = false
	prompt.focus()

	return confirmed
