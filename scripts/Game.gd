extends Node2D

enum State { WAITING, PLAYING, GAME_OVER }

var state := State.WAITING
var score := 0

@onready var bird = $Bird
@onready var hud = $HUD
@onready var spawner = $PipeSpawner

func _ready() -> void:
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
	spawner.active = true
	hud.hide_start_prompt()

func on_scored() -> void:
	score += 1
	hud.update_score(score)

func _on_bird_died() -> void:
	if state == State.GAME_OVER:
		return
	state = State.GAME_OVER
	bird.active = false
	spawner.active = false
	hud.show_game_over(score)
