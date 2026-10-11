extends Area2D

class_name HurtBox
signal Hurted()
signal Healed()
signal Died()

@export var Hearths := 3

func get_DMG(value: int):
	if Hearths <= 0:
		return

	Hearths = max(Hearths - value, 0)
	Hurted.emit()

	if Hearths <= 0:
		Died.emit()

func heal():
	if Hearths <= 0:
		return

	Hearths += 1
	Healed.emit()
