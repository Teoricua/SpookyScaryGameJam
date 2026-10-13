extends Area2D

class_name HitBox
# Turn on for hitboxes that should always deal damage, like an enemy's body.
@export var always_active := false

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	set_active(always_active)


func set_active(boolean: bool):
	for child in get_children():
		if child is not CollisionShape2D: continue
		# Deferred because this can be called while physics is reporting a hit.
		child.set_deferred("disabled", not boolean)


func _on_area_entered(area: Area2D) -> void:
	# Skip the HurtBox of whoever owns this HitBox.
	if area is HurtBox and area.get_parent() != get_parent():
		area.get_DMG(1)
