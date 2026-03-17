extends Node2D

signal scored

const SCROLL_SPEED = -200.0

func _physics_process(delta: float) -> void:
	position.x += SCROLL_SPEED * delta
	if position.x < -200:
		queue_free()

func _on_score_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("bird"):
		emit_signal("scored")
