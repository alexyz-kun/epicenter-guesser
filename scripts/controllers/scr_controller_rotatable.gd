class_name ControllerRotatable
extends Node3D

const MOUSE_SENSITIVITY: float = 0.003

var rotatable: Node3D
var camera: Camera3D
var curr_rotation: Vector2
var target_rotation: Vector2

# Base methods

func set_up(p_rotatable: Node3D, p_camera: Camera3D):
	rotatable = p_rotatable
	camera = p_camera


func _process(delta: float) -> void:
	_smooth_out_rotation(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_drag(event)


# Private methods

func _handle_drag(event: InputEventMouseMotion):
	if !SceneMain.manager.input.lmb_is_held:
		return
	
	target_rotation += MOUSE_SENSITIVITY * event.relative


func _smooth_out_rotation(delta: float):
	curr_rotation = UtilMath.delta_lerp_vec2(curr_rotation, target_rotation, 16, delta)
	
	var delta_rotation: Vector2 = target_rotation - curr_rotation
	rotatable.rotate(Vector3.UP, delta_rotation.x)
	rotatable.rotate(Vector3.RIGHT, delta_rotation.y)
