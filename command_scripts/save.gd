extends Command

func action(_command: Command, _player: Player) -> String:
	SaveManager.save()
	return "Saving..."
