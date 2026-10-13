extends CharacterBody2D


@export var speed := 80.0
# 1 starts walking right, -1 starts walking left.
@export var direction := 1

# Both are optional: the enemy still patrols if the scene has neither node.
@onready var animated_sprite = get_node_or_null("AnimatedSprite2D")
# A RayCast2D placed in front of the enemy's feet, pointing down.
@onready var ledge_check = get_node_or_null("LedgeCheck")

func _ready() -> void:
	# Remove the enemy when its HurtBox runs out of hearths.
	var hurt_box = get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.Died.connect(queue_free)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Turn around at walls, and at ledges when there is a LedgeCheck.
	if is_on_wall():
		direction = -direction
	elif ledge_check and is_on_floor() and not ledge_check.is_colliding():
		direction = -direction

	velocity.x = direction * speed

	if ledge_check:
		ledge_check.position.x = abs(ledge_check.position.x) * direction
	if animated_sprite:
		animated_sprite.flip_h = direction < 0

	move_and_slide()
