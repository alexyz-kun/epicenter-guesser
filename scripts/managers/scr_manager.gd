class_name Manager
extends Node

static var resource: ResourceManager
static var input: InputManager
static var audio: AudioManager

# Public methods

func set_up():
	resource = $ResourceManager
	input = $InputManager
	audio = $AudioManager
	
	resource.set_up()
