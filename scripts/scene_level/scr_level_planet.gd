class_name LevelPlanet
extends Node

var camera: Camera3D
var controller_rotatable: ControllerRotatable
var planet_mesh: MeshInstance3D
var planet_wave_parent: Node3D

# Base methods

func set_up(p_camera: Camera3D):
	camera = p_camera
	controller_rotatable = $ControllerRotatable
	planet_mesh = $PlanetMesh
	planet_wave_parent = $PlanetMesh
	
	controller_rotatable.set_up(planet_mesh, camera)
	
	_create_wave()


# Private methods

func _create_wave():
	var prefab_wave: PackedScene = load(SceneMain.manager.resource.prefab.level_planet_wave)
	var new_wave: LevelPlanetWave = prefab_wave.instantiate()
	planet_wave_parent.add_child(new_wave)
	new_wave.set_up(self, 0.503 * Vector3.RIGHT, 0.1)
