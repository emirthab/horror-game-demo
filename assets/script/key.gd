extends Spatial

export(int) var keyId

var outlineMaterial = SpatialMaterial.new()
var mainMaterial = preload("res://assets/geometry/article/key/Key.material")


func _ready():
	var next_pass = preload("res://assets/material_shader/key_outline.material")
	
	outlineMaterial = mainMaterial.duplicate()
	outlineMaterial.set_next_pass(next_pass)

func _process(delta):
	
	if Globals.raycastTrigger(self):
		$Key2.set_surface_material(0,outlineMaterial)
		if Input.is_action_just_pressed("pickUp"):
			Globals.ownedKeys.append(keyId)
			rpc("getKey")

	else:
		$Key2.set_surface_material(0,mainMaterial)
		
remotesync func getKey():
	queue_free()


