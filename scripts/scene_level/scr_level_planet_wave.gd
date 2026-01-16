class_name LevelPlanetWave
extends MeshInstance3D

const WAVE_FRONT_THICKNESS: float = 0.01

var planet: LevelPlanet
var debug_wave_front: MeshInstance3D

var epicenter: Vector3
var epicenter_pitch_axis: Vector3

var curr_wave_front: Vector3
var prev_wave_front: Vector3

var travel_t: float
var travel_t_speed: float

# Base methods

func set_up(p_planet: LevelPlanet, p_epicenter: Vector3, p_travel_t_speed: float):
	debug_wave_front = $Debug_WaveFront
	
	planet = p_planet
	epicenter = p_epicenter
	travel_t_speed = p_travel_t_speed
	
	var epicenter_transform_origin: Vector3 = p_planet.planet_mesh.global_position
	var epicenter_transform: Transform3D = Transform3D(
		Vector3.RIGHT, Vector3.UP, Vector3.FORWARD,
		epicenter_transform_origin)
	epicenter_transform = epicenter_transform.looking_at(epicenter, Vector3.UP)
	
	look_at(epicenter)
	epicenter_pitch_axis = basis.x


func _process(delta: float) -> void:
	travel_t += travel_t_speed * delta
	if travel_t > 1.0:
		travel_t -= 1.0
	
	var curr_wave_front_rotation: float = lerpf(0, PI, travel_t)
	var prev_wave_front_rotation: float = lerpf(0, PI, max(0, travel_t - WAVE_FRONT_THICKNESS))
	
	var base: Vector3 = epicenter
	curr_wave_front = base.rotated(epicenter_pitch_axis, curr_wave_front_rotation)
	prev_wave_front = base.rotated(epicenter_pitch_axis, prev_wave_front_rotation)
	
	debug_wave_front.global_position = curr_wave_front
	
	_create_wave_mesh()


# Private methods

func _create_wave_mesh():
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	const SEGMENT_COUNT: float = 32
	for i in SEGMENT_COUNT:
		var curr_seg_angle: float = lerpf(0, 2 * PI, float(i + 1) / SEGMENT_COUNT)
		var prev_seg_angle: float = lerpf(0, 2 * PI, float(i + 0) / SEGMENT_COUNT)
		
		var curr_seg_pos: Vector2 = Vector2(cos(curr_seg_angle), sin(curr_seg_angle))
		var prev_seg_pos: Vector2 = Vector2(cos(prev_seg_angle), sin(prev_seg_angle))
		
		var curr_ring_radius: float = curr_wave_front.y
		var prev_ring_radius: float = prev_wave_front.y
		
		var curr_ring_z: float = -curr_wave_front.x
		var prev_ring_z: float = -prev_wave_front.x
		
		var a_plane: Vector2 = curr_ring_radius * prev_seg_pos
		var b_plane: Vector2 = curr_ring_radius * curr_seg_pos
		var c_plane: Vector2 = prev_ring_radius * curr_seg_pos
		var d_plane: Vector2 = prev_ring_radius * prev_seg_pos
		
		var a: Vector3 = Vector3(a_plane.x, a_plane.y, curr_ring_z)
		var b: Vector3 = Vector3(b_plane.x, b_plane.y, curr_ring_z)
		var c: Vector3 = Vector3(c_plane.x, c_plane.y, prev_ring_z)
		var d: Vector3 = Vector3(d_plane.x, d_plane.y, prev_ring_z)
		
		_add_face(a, b, c, d)
	
	# End drawing.
	mesh.surface_end()
	pass


func _add_face(a: Vector3, b: Vector3, c: Vector3, d: Vector3):
	_add_tri(a, b, c)
	_add_tri(a, c, d)


func _add_tri(a: Vector3, b: Vector3, c: Vector3):
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
