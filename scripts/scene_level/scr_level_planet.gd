class_name LevelPlanet
extends Node

var camera: Camera3D
var controller_rotatable: ControllerRotatable
var planet_mesh: MeshInstance3D
var wave_mesh: MeshInstance3D

var wave_t: float = 0.3
var wave_vec: Vector3
var wave_radius: float = 0

# Base methods

func set_up(p_camera: Camera3D):
	camera = p_camera
	controller_rotatable = $ControllerRotatable
	planet_mesh = $PlanetMesh
	wave_mesh = $WaveMesh
	
	controller_rotatable.set_up(planet_mesh, camera)
	
	_create_wave(wave_mesh.mesh)


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# _create_wave(wave_mesh.mesh)
	pass


# Private methods

func _create_wave(mesh: ImmediateMesh):
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	const SEGMENT_COUNT: float = 32
	for i in SEGMENT_COUNT:
		var t: float = float(i) / SEGMENT_COUNT
		var angle_0: float = lerpf(0, 2 * PI, float(i) / SEGMENT_COUNT)
		var angle_1: float = lerpf(0, 2 * PI, float(i + 1) / SEGMENT_COUNT)
		
		var a: Vector3 = Vector3(cos(angle_0), sin(angle_0), 0)
		var a_next: Vector3 = Vector3(cos(angle_1), sin(angle_1), 0)
		var b_next: Vector3 = a_next
		b_next.z = .1
		var b: Vector3 = a
		b.z = .1
		
		_add_face(a, a_next, b_next, b, mesh)
	
	# End drawing.
	mesh.surface_end()
	pass


func _add_face(a: Vector3, b: Vector3, c: Vector3, d: Vector3, mesh: ImmediateMesh):
	_add_tri(a, b, c, mesh)
	_add_tri(a, c, d, mesh)


func _add_tri(a: Vector3, b: Vector3, c: Vector3, mesh: ImmediateMesh):
	var ba: Vector3 = b - a
	var ca: Vector3 = c - a
	var normal: Vector3 = ca.cross(ba).normalized()
	
	mesh.surface_set_normal(normal)
	mesh.surface_set_uv(Vector2(0, 0))
	mesh.surface_add_vertex(a)
	
	mesh.surface_set_normal(normal)
	mesh.surface_set_uv(Vector2(0, 1))
	mesh.surface_add_vertex(b)
	
	mesh.surface_set_normal(normal)
	mesh.surface_set_uv(Vector2(1, 1))
	mesh.surface_add_vertex(c)
