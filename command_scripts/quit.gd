extends Command

func action(_command: Command, player: Player) -> String:
	var input_prompt = ">%s" % player.raw_text
	var prompt_response = \
"Your score is 0 (total of 350 points), in 0 moves.
This gives you the rank of Beginner.
Do you wish to leave the game? (Y is affirmative): >"
	player.set_prompt("%s\n%s" % [input_prompt, prompt_response])
	var input: String = await prompt_signal
	player.reset_prompt()

	if ["y", "yes"].has(input.get_slice(" ", 0)):
		player.get_tree().quit()

	return "%s%s\nOk." % [prompt_response, input]
