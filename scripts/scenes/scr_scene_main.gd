class_name SceneMain
extends Node

static var manager: Manager
static var active_scene: Node3D

var active_scene_parent: Node3D

# Base methods

func _ready() -> void:
	manager = $Managers
	active_scene_parent = $ActiveSceneParent
	
	manager.set_up()
	
	var new_scene_prefab: PackedScene = load(manager.resource.scene.level)
	var new_scene: Node3D = new_scene_prefab.instantiate()
	active_scene_parent.add_child(new_scene)
	
	var scene_example: SceneLevel = new_scene
	scene_example.on_scene_active()
