extends KinematicBody

var velocity = Vector3()
var direction = Vector3()
var speed = 2.4
var acceleration = 5
var air_acceleration : float = 5
var mouse_sensivity = 0.1
var jump_power = 3.3
var max_terminal_velocity : float = 13
var gravity : float = 0.13
var y_velocity : float


var speedTimeLimit = 6.5
var speedTime = 0
var canFast = true

var lastTarget = null
# Accessing variables in uı node
onready var UI = get_tree().get_current_scene().get_node(str(Globals.scenename,"/UI"))

func _ready():
	
	print(Globals.language)

	#Mouse visibility
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	
	
func _process(delta):
	#if player has velocity, movement data will send other players.
	if velocity != Vector3(0,0,0):
		rpc_unreliable("sendPose",global_transform)
		
	animationNetwork()
	
	aimTrigger()
	

func _physics_process(delta):
	
	
	#Run movement codes only self client.
	handle_movement(delta)
	speedLimit(delta)



func handle_movement(delta):
	
	#Reset direction vector 
	direction = Vector3() 

	#Directions
	if Input.is_action_pressed("move_forward"):
		if $raycast_down.is_colliding() && !$raycast_up.is_colliding():
			y_velocity = 1
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
	
	# listing keys when pressed
	if Input.is_action_just_pressed("keyInventory"):
		Globals.make_Array_Key_List()
		UI.set_bottom_info(Globals.key_Message)
	if Input.is_action_just_released("keyInventory"):
		UI.set_bottom_info("")
		

func _input(event):

	#One click
	var just_pressed = event.is_pressed() and not event.is_echo()
	
	#Mouse visibility changes when esc is pressed.
	if Input.is_key_pressed(KEY_ESCAPE) and just_pressed:
		if Input.get_mouse_mode() == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	#Speed Up.
	if Input.is_key_pressed(KEY_SHIFT):
		if canFast == true:
			speed = 4.7
		else:
			speed = 2.4
	else:
		speed = 2.4
	


	#Camera and character rotation:
	#In left and right rotation, the camera rotates with the character. 
	#Only the camera rotates when looking up and down.

	if event is InputEventMouseMotion && Input.get_mouse_mode() != 0:
		rotate_y(deg2rad(-event.relative.x * mouse_sensivity))
		$pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensivity))
		$pivot.rotation.x = clamp($pivot.rotation.x,deg2rad(-90),deg2rad(90))
	
	if Input.is_action_just_pressed("toggle_flashlight"):
		if Globals.flashLight == true:
			
			if $oil_lamp.visible == true:
				$oil_lamp.visible = false
				rpc("flashLight","false")
				
			elif $oil_lamp.visible == false:
				$oil_lamp.visible = true
				rpc("flashLight","true")

func speedLimit(delta):
	
	# /- Fast run limitations -\
	#'Resultant' is velocity vector's x and velocity vector's z resultant.
	#So 'resultant' is a speed via velocity. (estimated value)
	#'SpeedTime' is a "The time the current speed is driving"
	#When the speed reaches the limit, the timer will be activated and will not be accelerated during the timer.
	#If the acceleration stops(release shift) , the 'speedTime' will reverse.

	var resultant = sqrt((velocity.x * velocity.x) + (velocity.z * velocity.z))
	if resultant > 3.5:
		if speedTime > speedTimeLimit:
			canFast = false
			$SpeedLimit.start()
		else:
			speedTime += delta
	elif speedTime > 0:
		speedTime -= delta


func _on_SpeedLimit_timeout():
	canFast = true
	speedTime = 0

func animationNetwork():
	var resultant = sqrt((velocity.x * velocity.x) + (velocity.z * velocity.z))
	if y_velocity < 0:
		if resultant > 3.5:
			rpc("setAnimation","run")
		elif resultant > 0:
			rpc("setAnimation","walk")
		elif resultant == 0:
			rpc("setAnimation","idle")
	else:
		rpc("setAnimation","jump")


#send signal to "Globals.gd" when aim entered or exited.
func aimTrigger():
	var aim = $pivot/Aim
	if aim.is_colliding():
		var col = aim.get_collider()
		if lastTarget != col:
			if lastTarget != null:
				Globals.emit_signal("_on_aim_exited",lastTarget)
			Globals.emit_signal("_on_aim_entered",col)
			lastTarget = col
			
	elif lastTarget != null:
		Globals.emit_signal("_on_aim_exited",lastTarget)
		lastTarget = null
# ||| ------------- Remote Funcs ------------- ||| #

remote func sendPose(pos):
	global_transform = pos


