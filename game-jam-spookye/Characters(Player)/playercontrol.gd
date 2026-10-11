extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ATTACK_ANIMATION = &"AttackHorseman"
const RUN_ANIMATION = &"RunHorseman"
const IDLE_ANIMATION = &"IdleHorseman"
const DEATH_ANIMATION = &"DeathHorseman"
const HURT_ANIMATION = &"HurtHorseman"
# Add an action with this name in Project Settings > Input Map to enable jumping.
#const JUMP_ACTION = &"Jump"

@onready var animated_sprite = $AnimatedSprite2D

var is_attacking := false

func _ready() -> void:
	# The attack has to end on its own so the run/idle animation can come back.
	animated_sprite.sprite_frames.set_animation_loop(ATTACK_ANIMATION, false)
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("MoveJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement never waits for the attack, so both can happen at once.
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_pressed("Attack") and not is_attacking:
		is_attacking = true
		animated_sprite.play(ATTACK_ANIMATION)

	# Run/idle only take over the sprite once the attack has played through.
	if not is_attacking:
		animated_sprite.play(RUN_ANIMATION if direction else IDLE_ANIMATION)

	move_and_slide()

func _on_animation_finished() -> void:
	if animated_sprite.animation == ATTACK_ANIMATION:
		is_attacking = false


func _on_hurt_box_died() -> void:
	pass # Replace with function body.
	animated_sprite.play(DEATH_ANIMATION)

func _on_hurt_box_healed() -> void:
	pass # Replace with function body.


func _on_hurt_box_hurted() -> void:
	pass # Replace with function body.
	animated_sprite.play(HURT_ANIMATION)
