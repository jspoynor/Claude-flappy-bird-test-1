extends Node2D

enum State { PLAYING, GAME_OVER }

var state := State.PLAYING
var score := 0

@onready var bird = $Bird
@onready var hud = $HUD
@onready var spawner = $PipeSpawner

func _ready() -> void:
	bird.active = true
	spawner.active = true
	hud.update_score(0)
	bird.died.connect(_on_bird_died)

func _unhandled_input(event: InputEvent) -> void:
	if state == State.GAME_OVER and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

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
