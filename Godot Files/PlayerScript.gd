extends CharacterBody2D


const SPEED = 850.0 # Speed the player moves at when using the movement keys
const SPEED_AIR = 1100.0 # Speed the player moves at when in the air
const JUMP_VELOCITY = -1250.0 # Speed the player jumps at
const PAST = 2 # Layer the past is on
const PRESENT = 1 # Layer the present is on
var can_jump = true
var speed
var jump_vel
var can_swap = true
var has_key = false

@onready var animations = $AnimationPlayer

func _ready():
	# Set the stuck checker layer to fix a bug
	# where the first time you tried changing time,
	# it wouldn't work
	$StuckChecker.collision_layer = 3
	$StuckChecker.collision_mask = 3
	Engine.time_scale = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func update_layer_ui():
	if collision_layer == PAST:
		$"../CanvasLayer/HUD/CurrentTimeDisplay".text = "Before"
	elif collision_layer == PRESENT:
		$"../CanvasLayer/HUD/CurrentTimeDisplay".text = "After"

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
		$"../CanvasLayer/HUD/CurrentTimeDisplay".text = "[color=#FF0000]ERROR: DESTINATION OBSTRUCTED"
		await get_tree().create_timer(0.5).timeout
		update_layer_ui()
	else:
		$CooldownTimer.start()
		can_swap = false
		# Set the collision to the new layer
		collision_layer = layer
		collision_mask = layer
		if layer == PRESENT:
			print("Now in present")
			# Show the present tilemap
			$"../TileMapPast".hide()
			$"../TileMapPresent".show()
			# Show the present background
			$"../ParallaxBackgroundPresent".show()
			$"../ParallaxBackgroundPast".hide()
			$"../Water".position = Vector2(0, -64)
		elif layer == PAST:
			print("Now in past")
			# Show the past tilemap
			$"../TileMapPresent".hide()
			$"../TileMapPast".show()
			# Show the past background
			$"../ParallaxBackgroundPresent".hide()
			$"../ParallaxBackgroundPast".show()
			$"../Water".position = Vector2(0, 0)
		else:
			# Print an error if on another layer
			print("Error with time swapping in function")
		update_layer_ui()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if $"." in $"../Water".get_overlapping_bodies():
			velocity.y += (gravity * 0.5) * delta
		else: velocity.y += gravity * delta

	# Handle jump and coyote time.
	if can_jump == false and is_on_floor():
		can_jump = true

	if Input.is_action_just_pressed("move_jump") and can_jump:
		jump_vel = JUMP_VELOCITY
		if $"." in $"../Water".get_overlapping_bodies():
			jump_vel = JUMP_VELOCITY * 0.95
		velocity.y = jump_vel
		can_jump = false

	if (is_on_floor() == false) and can_jump and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start()
	if Input.is_action_just_pressed("time_travel") and Engine.time_scale != 0:
		# Get the current collision layers and masks and change them depending
		# On the laer the player is currently on
		if can_swap:
			if collision_layer == PAST:
				change_time(PRESENT)
			elif collision_layer == PRESENT:
				change_time(PAST)
			else:
				# Print an error if on another layer
				print("Error in time swapping")
		else:
			$"../CanvasLayer/HUD/CurrentTimeDisplay".text = "[color=#FF0000]ERROR: DEVICE COOLING DOWN"
			await get_tree().create_timer(0.5).timeout
			update_layer_ui()

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if is_on_floor():
		speed = SPEED
		if Input.is_action_pressed("sprint"):
			speed = speed * 1.25
	else:
		speed = SPEED_AIR
	if $"." in $"../Water".get_overlapping_bodies():
		speed = speed * 0.65
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


	move_and_slide()


func _on_coyote_timer_timeout():
	# Turn off jumping after coyote time expires
	can_jump = false


func _on_cooldown_timer_timeout():
	# Turn on time travel on cooldown expiration
	can_swap = true


func _on_key_area_entered(_area):
	if collision_layer == PRESENT:
		if not has_key:
			has_key = true
			print("key has been recovered")
		else:
			print("already gained key")
	else:
		pass


func _on_helicopter_exit_area_entered(_area):
	if collision_layer == PAST:
		if has_key:
			print("exiting level")
		else:
			print("needs a key")
	else:
		pass
