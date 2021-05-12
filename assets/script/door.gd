extends Spatial

export(bool) var lock = false
export(int) var doorId

var open = false

func _process(delta):
	
	if Globals.raycastTrigger($pivot/KinematicBody):
		if Input.is_action_just_pressed("pickUp"):
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
		

remotesync func _doorEvent(_event):
	if _event == "open":
		open = true
		$AnimationPlayer.play("opening")
	elif _event == "close":
		open = false
		$AnimationPlayer.play("closing")

remotesync func _doorUnlock():
	lock = false
	#unlock sound
remotesync func _doorNoKey():
	$AnimationPlayer.play("shake")
	#cant unlock sound
	
