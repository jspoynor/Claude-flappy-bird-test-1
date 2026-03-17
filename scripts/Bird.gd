extends CharacterBody2D

signal died

const GRAVITY = 1200.0
const FLAP_FORCE = -400.0
const AUTO_FLAP_TARGET_Y = 380.0

const WING_UP = preload("res://assets/sprites/unitytut-birdwingup.png")
const WING_DOWN = preload("res://assets/sprites/unitytut-birdwingdown.png")

var active := false
var auto_flap := false
var _dead := false
var _ragdoll := false

@onready var _wing: Sprite2D = $WingSprite

func _physics_process(delta: float) -> void:
	if auto_flap:
		velocity.y += GRAVITY * delta
		if position.y > AUTO_FLAP_TARGET_Y:
			velocity.y = FLAP_FORCE
		move_and_slide()
		_wing.texture = WING_UP if velocity.y < 0 else WING_DOWN
		return

	if not active and not _ragdoll:
		return

	if _ragdoll:
		velocity.y += GRAVITY * delta
		rotation += 3.0 * delta
		_wing.texture = WING_DOWN
		move_and_slide()
		return

	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = FLAP_FORCE

	move_and_slide()

	# Swap wing texture based on vertical velocity
	_wing.texture = WING_UP if velocity.y < 0 else WING_DOWN

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
	_ragdoll = true
	emit_signal("died")
