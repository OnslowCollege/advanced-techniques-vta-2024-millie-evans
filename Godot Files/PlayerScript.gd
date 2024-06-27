extends CharacterBody2D


const SPEED = 250.0 # Speed the player moves at when using the movement keys
const JUMP_VELOCITY = -250.0 # Speed the player jumps at
const PAST = 2 # Layer the past is on
const PRESENT = 1 # Layer the present is on

var can_jump = true

func _ready():
	# Set the stuck checker layer to fix a bug
	# where the first time you tried changing time,
	# it wouldn't work
	$StuckChecker.collision_layer = 3
	$StuckChecker.collision_mask = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func change_time(layer):
	# Set the stuck checker layer to the layer you are going to change to
	$StuckChecker.collision_layer = layer
	$StuckChecker.collision_mask = layer
	# Check what is colliding with the checker - ignore the player
	var is_stuck = $StuckChecker.get_overlapping_bodies()
	is_stuck.erase($".")
	# Reset the stuck checker layer
	$StuckChecker.collision_layer = 3
	$StuckChecker.collision_mask = 3
	if is_stuck:
		# Print to the log for debugging
		print(is_stuck)
		print("Player cannot change layer")
	else:
		# Set the collision to the new layer
		collision_layer = layer
		collision_mask = layer
		if layer == PRESENT:
			print("Now in present")
			# Show the present tilemap
			$"../TileMapPast".hide()
			$"../TileMapPresent".show()
		elif layer == PAST:
			print("Now in past")
			# Show the past tilemap
			$"../TileMapPresent".hide()
			$"../TileMapPast".show()
		else:
			# Print an error if on another layer
			print("Error with time swapping in function")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump and coyote time.
	if can_jump == false and is_on_floor():
		can_jump = true

	if Input.is_action_just_pressed("move_jump") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false

	if (is_on_floor() == false) and can_jump and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start()

	if Input.is_action_just_pressed("time_travel"):
		# Get the current collision layers and masks and change them depending
		# On the laer the player is currently on
		if collision_layer == PAST and collision_mask == PAST:
			change_time(PRESENT)
		elif collision_layer == PRESENT and collision_mask == PRESENT:
			change_time(PAST)
		else:
			# Print an error if on another layer
			print("Error in time swapping")

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_coyote_timer_timeout():
	# Turn off jumping after coyote time expires
	can_jump = false
