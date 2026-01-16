class_name SceneLevel
extends Node3D

var camera: Camera3D
var planet: LevelPlanet
var first_person: ControllerFirstPerson

# Public methods

func on_scene_active() ->  void:
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	camera = $Node3D/Camera3D
	planet = $Node3D/Planet
	first_person = $Node3D/FirstPerson
	
	attach_camera_to_planet()
	# first_person.attach_camera(camera)


# Private methods

func attach_camera_to_planet():
	camera.global_position = planet.global_position - 1 * Vector3.FORWARD
	camera.look_at(planet.global_position)
	planet.set_up(camera)
