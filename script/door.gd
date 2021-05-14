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
					# yine buradada fonksiyonu direk kullanmak yerine rpc üzerinden çalıştırmanın vanatajı nedir ?.
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
		

#kapıyı açıp kapayan fonksiyon
remotesync func _doorEvent(_event):
	if _event == "open":
		open = true
		$AnimationPlayer.play("opening")
	elif _event == "close":
		open = false
		$AnimationPlayer.play("closing")

#kapının kilidini kontrol eden fonksiyon
remotesync func _doorUnlock():
	lock = false
	#unlock sound
	
remotesync func _doorNoKey():
	$AnimationPlayer.play("shake")
	#cant unlock sound
	
