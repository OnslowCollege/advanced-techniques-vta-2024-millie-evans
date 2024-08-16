extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://urbanlevel.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_levels_button_pressed():
	$MainMenuHbox.hide()
	$LevelsHbox.show()

func _on_levels_back_button_pressed():
	$MainMenuHbox.show()
	$LevelsHbox.hide()

func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://urbanlevel.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://menus/options.tscn")
