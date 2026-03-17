extends CanvasLayer

func _ready() -> void:
	$GameOverPanel.visible = false

func update_score(value: int, is_high_score: bool = false) -> void:
	$ScoreLabel.text = str(value)
	if is_high_score:
		$ScoreLabel.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	else:
		$ScoreLabel.remove_theme_color_override("font_color")

func show_game_over(score: int, high_score: int) -> void:
	$GameOverPanel/FinalScoreLabel.text = "Score: " + str(score)
	$GameOverPanel/HighScoreLabel.text = "Best: " + str(high_score)
	$GameOverPanel.visible = true

func hide_game_over() -> void:
	$GameOverPanel.visible = false

func hide_start_prompt() -> void:
	$StartPromptLabel.visible = false
