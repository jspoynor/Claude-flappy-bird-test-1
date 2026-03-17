extends Node2D

enum State { WAITING, PLAYING, GAME_OVER }

var state := State.WAITING
var score := 0
var high_score := 0

@onready var bird = $Bird
@onready var hud = $HUD
@onready var spawner = $PipeSpawner

func _ready() -> void:
	_load_high_score()
	bird.auto_flap = true
	spawner.active = false
	hud.update_score(0)
	bird.died.connect(_on_bird_died)

func _unhandled_input(event: InputEvent) -> void:
	if state == State.WAITING and event.is_action_pressed("ui_accept"):
		_start_game()
	elif state == State.GAME_OVER and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _start_game() -> void:
	state = State.PLAYING
	bird.auto_flap = false
	bird.active = true
	hud.hide_start_prompt()
	await get_tree().create_timer(1.5).timeout
	if state == State.PLAYING:
		spawner.active = true

func on_scored() -> void:
	score += 1
	if score > high_score:
		high_score = score
		_save_high_score()
		hud.update_score(score, true)
	else:
		hud.update_score(score, false)

func _on_bird_died() -> void:
	if state == State.GAME_OVER:
		return
	state = State.GAME_OVER
	bird.active = false
	spawner.active = false
	hud.show_game_over(score, high_score)

func _load_high_score() -> void:
	if FileAccess.file_exists("user://highscore.dat"):
		var f = FileAccess.open("user://highscore.dat", FileAccess.READ)
		high_score = f.get_32()
		f.close()

func _save_high_score() -> void:
	var f = FileAccess.open("user://highscore.dat", FileAccess.WRITE)
	f.store_32(high_score)
	f.close()
