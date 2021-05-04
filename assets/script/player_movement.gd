extends KinematicBody

var velocity = Vector3()
var direction = Vector3()
var speed = 1.4
var acceleration = 5
var air_acceleration : float = 5
var mouse_sensivity = 0.1
var jump_power = 4.8
var max_terminal_velocity : float = 13
var gravity : float = 0.13
var y_velocity : float


func _ready():
	#Mouse visibility
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	
	
func _process(delta):
	#if player has velocity, movement data will send other players.
	if velocity != Vector3(0,0,0):
		rpc_unreliable("sendPose",global_transform)
	

func _physics_process(delta):
	
	#Run movement codes only self client.
	if is_network_master():
		handle_movement(delta)


func handle_movement(delta):
	
	#Reset direction vector 
	direction = Vector3() 

	#Directions
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	
	#If the player is on the ground, normal acceleration is used.
	#If it is not on the ground, the acceleration in the air is used.
	
	var accel = acceleration if is_on_floor() else air_acceleration
	
	
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	direction = direction.normalized()
	velocity = direction * speed
	
	#Gravity and falling.
	if is_on_floor():
		y_velocity = -0.01
	elif !is_on_floor():
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)

	#Jump mechanic.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		y_velocity = jump_power

	#Kinematic velocity equal to variable velocity.
	velocity.y = y_velocity
	
	#Apply mechanics to move.
	move_and_slide(velocity,Vector3.UP)


func _input(event):
	
	#One click
	var just_pressed = event.is_pressed() and not event.is_echo()
	
	#Mouse visibility changes when esc is pressed.
	if Input.is_key_pressed(KEY_ESCAPE) && just_pressed:
		if Input.get_mouse_mode() == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	#Speed Up.
	if Input.is_key_pressed(KEY_SHIFT):
		speed = 3.7
	else:
		speed = 1.4
	

	#Camera and character rotation:
	#In left and right rotation, the camera rotates with the character. 
	#Only the camera rotates when looking up and down.

	if event is InputEventMouseMotion && Input.get_mouse_mode() != 0:
		rotate_y(deg2rad(-event.relative.x * mouse_sensivity))
		$Camera.rotate_x(deg2rad(-event.relative.y * mouse_sensivity))
		$Camera.rotation.x = clamp($Camera.rotation.x,deg2rad(-90),deg2rad(90))

		
# ||| ------------- Remote Funcs ------------- ||| #

remote func sendPose(pos):
	global_transform = pos
