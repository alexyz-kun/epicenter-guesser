class_name InputManager
extends Node

signal lmb_pressed
signal lmb_released

var lmb_is_held: bool

# Base methods

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				lmb_pressed.emit()
				lmb_is_held = true
		if event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT:
				lmb_released.emit()
				lmb_is_held = false
	pass
