class_name ControllerFirstPerson
extends Node3D

const MOUSE_SENSITIVITY: float = 0.005
const BASE_SPEED: float = 2
const CAMERA_MIN_PITCH: float = -0.33 * PI
const CAMERA_MAX_PITCH: float = 0.33 * PI

var camera: Camera3D

var camera_angle: Vector2
var target_camera_angle: Vector2

var delta_position: Vector3
var speed: float

# Base methods

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	_handle_camera_angle(delta)
	_handle_position(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)


# Public method

func attach_camera(p_camera: Camera3D):
	p_camera.reparent(self)
	camera = p_camera


# Private methods

func _handle_position(delta: float):
	if camera == null:
		return
	
	# Update position
	position += speed * delta_position * delta
	
	# Handle new input
	var north_is_pressed: int = 1 if Input.is_action_pressed("input_up") else 0
	var south_is_pressed: int = 1 if Input.is_action_pressed("input_down") else 0
	var east_is_pressed: int = 1 if Input.is_action_pressed("input_right") else 0
	var west_is_pressed: int = 1 if Input.is_action_pressed("input_left") else 0
	
	var z_axis: int = north_is_pressed - south_is_pressed
	var x_axis: int = east_is_pressed - west_is_pressed
	
	if z_axis == 0 and x_axis == 0:
		speed = UtilMath.delta_lerp(speed, 0, 16, delta)
	else:
		speed = UtilMath.delta_lerp(speed, BASE_SPEED, 8, delta)
		delta_position = Vector3(float(x_axis), 0, float(-z_axis)).normalized()
		delta_position = delta_position.rotated(Vector3.UP, -camera_angle.x)


func _handle_camera_angle(delta: float):
	if camera == null:
		return
	
	# Smooth out camera angle
	camera_angle = UtilMath.delta_lerp_vec2(camera_angle, target_camera_angle, 32, delta)
	
	camera.transform.basis = Basis()
	camera.rotate_object_local(Vector3.UP, -camera_angle.x)
	camera.rotate_object_local(Vector3.RIGHT, -camera_angle.y)


func _handle_mouse_motion(event_mouse_motion: InputEventMouseMotion):
	if camera == null:
		return
	
	var mouse_delta: Vector2 = event_mouse_motion.relative
	target_camera_angle += MOUSE_SENSITIVITY * mouse_delta
	target_camera_angle.y = clampf(target_camera_angle.y, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)
