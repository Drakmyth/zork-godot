extends PanelContainer

func set_room_name(room_name: String) -> void:
	$Margin/Layout/lblRoom.text = room_name

func set_score(score: int) -> void:
	$Margin/Layout/ScoreBox/Score.text = String.num_int64(score)

func set_moves(moves: int) -> void:
	$Margin/Layout/MovesBoxMargin/MovesBox/Moves.text = String.num_int64(moves)
