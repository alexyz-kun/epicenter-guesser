class_name AudioManager
extends Node

var music_player: AudioStreamPlayer
var sound_player: AudioStreamPlayer

# Base method

func set_up():
	music_player = $MusicPlayer
	sound_player = $SoundPlayer
