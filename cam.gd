
extends Camera

const MOUSE_SENSITIVITY = 0.002


# The camera movement speed (tweakable using the mouse wheel)
var move_speed := 0.5

# Stores where the camera is wanting to go (based on pressed keys and speed modifier)


# Stores the effective camera velocity
var velocity := Vector3()

# The initial camera node rotation
var initial_rotation := rotation.y


func _input(event: InputEvent) -> void:
	# Mouse look (effective only if the mouse is captured)
	if event is InputEventMouseMotion and Input.is_key_pressed(KEY_C):
		# Horizontal mouse look
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		# Vertical mouse look, clamped to -90..90 degrees
		rotation.x = clamp(rotation.x - event.relative.y * MOUSE_SENSITIVITY, deg2rad(-90), deg2rad(90))



func _process(delta: float) -> void:
	var motion := Vector3()
	if Input.is_key_pressed(KEY_W):
		motion.z = -1
	elif Input.is_key_pressed(KEY_S):
		motion.z = 1
	else:
		motion.z = 0
		
	if Input.is_key_pressed(KEY_A):
		motion.x = -1
	elif Input.is_key_pressed(KEY_D):
		motion.x = 1
	else:
		motion.x = 0

	if Input.is_key_pressed(KEY_Q):
		motion.y = -1
	elif Input.is_key_pressed(KEY_E):
		motion.y = 1
	else:
		motion.y = 0

	transform.origin += motion * delta


