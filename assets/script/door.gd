# --------- Door - System -------- #

#If the "pickUp" button is pressed while looking at the door, 
#it first checks whether the door is locked or not.
#If the door is locked, it checks the "ownedKeys" variable in the "Globals.gd" script.
#If there is an id matching the id of the door in the "ownedKeys" array, the door is unlocked.

#For example:
#Globals.ownedKeys = [0,1,2]
#If doorId = 0 or 1 or 2, the door will open.
#If doorId = 3 or 4 or 5 ... the door will not open.
# -------------------------------- #



extends Spatial

export(bool) var lock = false
export(int) var doorId

var open = false
var isAiming = false



func _input(event):
	if Input.is_action_just_pressed("pickUp"):
		if Globals.getAimObject() == $pivot/KinematicBody:
			if lock == false:
				if open == true:
					rpc("_doorEvent","close")
					open = false
				elif open == false:
					rpc("_doorEvent","open")
					open = true

			elif lock == true:
				
				if Globals.ownedKeys.has(doorId):
					rpc("_doorUnlock")
				else:
					rpc("_doorNoKey")


#The "RPC" function opens or closes the door on both this client and other clients.

remotesync func _doorEvent(_event):
	if _event == "open":
		open = true
		$AnimationPlayer.play("opening")
	elif _event == "close":
		open = false
		$AnimationPlayer.play("closing")


#Unlocking the door only (the door won't open or close)

remotesync func _doorUnlock():
	lock = false
	#TODO unlock sound
	
#It works when the door is locked and there is no key. Shaking animation etc.

remotesync func _doorNoKey():
	$AnimationPlayer.play("shake")
	#TODO cant unlock sound
	
