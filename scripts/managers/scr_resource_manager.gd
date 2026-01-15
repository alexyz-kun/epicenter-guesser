class_name ResourceManager
extends Node

static var scene: SceneResourceManager
static var prefab: PrefabResourceManager
static var music: MusicResourceManager
static var sound: SoundResourceManager

# Public methods

func set_up():
	scene = $SceneResourceManager
	prefab = $PrefabResourceManager
	music = $MusicResourceManager
	sound = $SoundResourceManager
