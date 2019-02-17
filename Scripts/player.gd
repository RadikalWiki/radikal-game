extends KinematicBody2D

const GRAVITY = 800.0 # pixels/second/second
# Member variables

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const JUMP_SPEED = 400
const JUMP_MAX_AIRBORNE_TIME = 0.1

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false


func _physics_process(delta):
	var force = Vector2(0, GRAVITY)
	
	var jump = Input.is_action_pressed("jump")

	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump

