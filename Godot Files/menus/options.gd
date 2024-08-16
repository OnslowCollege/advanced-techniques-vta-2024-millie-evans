extends Control

var rainon = Global.rainon
var fullscreen = Global.fullscreen

func _ready():
	if rainon:
		$"Rain Button".button_pressed = true
	else:
		$"Rain Button".button_pressed = false
	if fullscreen:
		$FullscreenButton.button_pressed = true
	else:
		$FullscreenButton.button_pressed = false

func _on_rain_button_toggled(toggled_on):
	Global.rainon = toggled_on

func _on_back_button_pressed():
	if fullscreen:
		Global.fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		Global.fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _on_fullscreen_button_toggled(toggled_on):
	fullscreen = toggled_on
