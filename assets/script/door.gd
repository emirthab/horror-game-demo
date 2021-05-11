extends KinematicBody

var open = false

func _process(delta):
	var id =  get_tree().get_network_unique_id()
	
	if get_tree().get_current_scene().has_node(str(id)):
		
		var raycast = get_tree().get_current_scene().get_node(str((id),"/pivot/Aim"))
		
		if raycast.is_colliding():
			if raycast.get_collider() == self:
				if Input.is_action_just_pressed("pickUp"):
					if open == false:
						rpc("_doorEvent","open")
					else:
						rpc("_doorEvent","close")

remotesync func _doorEvent(_event):
	if _event == "open":
		open = true
		get_node("../../AnimationPlayer").play("opening")
	elif _event == "close":
		open = false
		get_node("../../AnimationPlayer").play("closing")
