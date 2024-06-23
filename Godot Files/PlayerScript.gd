extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const PAST = 1
const PRESENT = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if Input.is_action_just_pressed("time_travel"):
			# Get the current collision layers and masks and change them depending
			# On the time the player is currently in
			if collision_layer == 1 and collision_mask == 1:
				print("The player is now in the past")
				collision_layer = 2
				collision_mask = 2
				$"../TileMapPresent".hide()
				$"../TileMapPast".show()
			elif collision_layer == 2 and collision_mask == 2:
				print("The player is now in the present")
				collision_layer = 1
				collision_mask = 1
				$"../TileMapPast".hide()
				$"../TileMapPresent".show()
			else:
				print("Error in time swapping")

	move_and_slide()
