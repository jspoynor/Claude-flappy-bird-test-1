extends CanvasLayer

func _ready() -> void:
	var hs = 0
	if FileAccess.file_exists("user://highscore.dat"):
		var f = FileAccess.open("user://highscore.dat", FileAccess.READ)
		hs = f.get_32()
		f.close()
	if hs > 0:
		$VBoxContainer/HighScoreLabel.text = "Best: " + str(hs)
	else:
		$VBoxContainer/HighScoreLabel.text = ""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
