extends CharacterBody2D

signal died

const GRAVITY = 1200.0
const FLAP_FORCE = -400.0

var active := false
var _dead := false

func _physics_process(delta: float) -> void:
	if not active:
		return

	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = FLAP_FORCE

	move_and_slide()

	# Died by hitting pipe or ground
	if get_slide_collision_count() > 0:
		_kill()

	# Died by going off screen top or bottom
	if position.y < 0 or position.y > 730:
		_kill()

func _kill() -> void:
	if _dead:
		return
	_dead = true
	emit_signal("died")
