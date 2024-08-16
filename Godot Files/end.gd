extends Control


func _on_quit_menu_button_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
	Engine.time_scale = 1


func _on_quit_desktop_button_pressed():
	get_tree().quit()
