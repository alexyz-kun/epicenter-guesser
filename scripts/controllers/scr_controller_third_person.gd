class_name ControllerThirdPerson
extends CharacterBody3D

const MOUSE_SENSITIVITY: float = 0.005
const SCROLL_SENSITIVITY: float = 10
const BASE_SPEED: float = 2
const CAMERA_MIN_PITCH: float = 0.1 * PI
const CAMERA_MAX_PITCH: float = 0.4 * PI
const CAMERA_MIN_ZOOM: float = 1
const CAMERA_MAX_ZOOM: float = 2

var camera: Camera3D

var camera_angle: Vector2
var target_camera_angle: Vector2
var camera_distance: float = CAMERA_MAX_ZOOM
var target_camera_distance: float

var delta_position: Vector3
var speed: float

# Base methods

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	_handle_camera_zoom(delta)
	_handle_camera_pos(delta)
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
	
	# Update velocity
	velocity = speed * delta_position
	move_and_slide()
	
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
		delta_position = delta_position.rotated(Vector3.UP, -camera_angle.x + 0.5 * PI)


func _handle_camera_pos(delta: float):
	if camera == null:
		return
	
	# Smooth out camera angle
	camera_angle = UtilMath.delta_lerp_vec2(camera_angle, target_camera_angle, 32, delta)
	
	var altitude: float = camera_distance * sin(camera_angle.y)
	var plane_radius: float = camera_distance * cos(camera_angle.y)
	var plane_x: float = plane_radius * cos(camera_angle.x)
	var plane_z: float = plane_radius * sin(camera_angle.x)
	
	camera.position = Vector3(plane_x, altitude, plane_z)
	camera.look_at(position)


func _handle_camera_zoom(delta: float):
	
	# Smooth out camera distance
	camera_distance = UtilMath.delta_lerp(camera_distance, target_camera_distance, 16, delta)
	
	var scrolled_up: int = 1 if Input.is_action_just_released("input_scroll_up") else 0
	var scrolled_down: int = 1 if Input.is_action_just_released("input_scroll_down") else 0
	var scroll_axis: int = scrolled_up - scrolled_down
	
	target_camera_distance += SCROLL_SENSITIVITY * scroll_axis * delta
	target_camera_distance = clampf(target_camera_distance, CAMERA_MIN_ZOOM, CAMERA_MAX_ZOOM)


func _handle_mouse_motion(event_mouse_motion: InputEventMouseMotion):
	if camera == null:
		return
	
	var mouse_delta: Vector2 = event_mouse_motion.relative
	target_camera_angle += MOUSE_SENSITIVITY * mouse_delta
	target_camera_angle.y = clampf(target_camera_angle.y, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)
