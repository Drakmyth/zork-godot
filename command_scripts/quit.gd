extends Command

func action(_command: Command, player: Player) -> String:
	var message = \
"Your score is %d (total of %d points), in %d moves.
This gives you the rank of %s.
Do you wish to leave the game?" % [player.score, Player.SCORE_MAX, player.moves, player.get_rank()]

	var confirmed = await DialogManager.confirm(message)
	if confirmed:
		player.get_tree().quit()

	return "Ok."
