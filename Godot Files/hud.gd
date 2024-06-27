extends Control

func pause():
	print("Player is trying to pause the game")

func _on_pause_button_pressed():
	pause()

func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause()
