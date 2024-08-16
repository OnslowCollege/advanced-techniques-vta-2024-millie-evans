extends Control

func ready():
	Engine.time_scale = 1
	print("Game unpaused")
	$PauseMenu.hide()
	$CurrentTimeDisplay.show()
	$PauseButton.show()

# This function will toggle the pause state of the game
func pause():
	if Engine.time_scale == 1:
		Engine.time_scale = 0
		print("Game paused")
		$PauseMenu.show()
		$CurrentTimeDisplay.hide()
		$PauseButton.hide()
	else:
		Engine.time_scale = 1
		print("Game unpaused")
		$PauseMenu.hide()
		$CurrentTimeDisplay.show()
		$PauseButton.show()

# This function is connected to the pause button's pressed signal
func _on_pause_button_pressed():
	pause()

# This function runs every physics frame
func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause()
