extends Spatial


var next_pass = preload("res://assets/material_shader/key_outline.material")

export(int) var keyId

func _process(delta):
	
	if Globals.raycastTrigger($StaticBody):
		$Key2.get_surface_material(0).set_next_pass(next_pass)
		if Input.is_action_just_pressed("pickUp"):
			Globals.ownedKeys.append(keyId)
			queue_free()
	else:
		$Key2.get_surface_material(0).set_next_pass(null)


