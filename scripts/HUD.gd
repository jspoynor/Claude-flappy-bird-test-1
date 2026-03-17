extends CanvasLayer

func _ready() -> void:
	$GameOverPanel.visible = false

func update_score(value: int) -> void:
	$ScoreLabel.text = str(value)

func show_game_over(score: int) -> void:
	$GameOverPanel/FinalScoreLabel.text = "Score: " + str(score)
	$GameOverPanel.visible = true

func hide_game_over() -> void:
	$GameOverPanel.visible = false

func hide_start_prompt() -> void:
	$StartPromptLabel.visible = false
