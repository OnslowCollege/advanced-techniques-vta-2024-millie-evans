extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -250.0
const PAST = 1
const PRESENT = 2

func _ready():
	$StuckChecker.collision_layer = 3
	$StuckChecker.collision_mask = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func change_time(layer):
	$StuckChecker.collision_layer = layer
	$StuckChecker.collision_mask = layer
	var is_stuck = $StuckChecker.get_overlapping_bodies()
	is_stuck.erase($".")
	print(is_stuck)
	$StuckChecker.collision_layer = 3
	$StuckChecker.collision_mask = 3
	if is_stuck:
		print("Player cannot change layer")
	else:
		collision_layer = layer
		collision_mask = layer
		if layer == 1:
			$"../TileMapPast".hide()
			$"../TileMapPresent".show()
		elif layer == 2:
			$"../TileMapPresent".hide()
			$"../TileMapPast".show()
		else:
			print("Error with time swapping in function")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("time_travel"):
		# Get the current collision layers and masks and change them depending
		# On the time the player is currently in
		if collision_layer == 1 and collision_mask == 1:
			change_time(2)
		elif collision_layer == 2 and collision_mask == 2:
			change_time(1)
		else:
			print("Error in time swapping")

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
