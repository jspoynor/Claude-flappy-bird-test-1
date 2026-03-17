extends Node2D

const PipeScene = preload("res://scenes/entities/Pipe.tscn")
const SPAWN_X = 530.0
const MIN_Y = 200.0
const MAX_Y = 520.0

var active := false

func _on_timer_timeout() -> void:
	if not active:
		return
	var pipe = PipeScene.instantiate()
	pipe.position = Vector2(SPAWN_X, randf_range(MIN_Y, MAX_Y))
	pipe.scored.connect(_on_pipe_scored)
	get_parent().add_child(pipe)

func _on_pipe_scored() -> void:
	get_parent().on_scored()
