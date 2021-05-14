extends Spatial

export(int) var keyId
export(String) var keyName

var outlineMaterial = SpatialMaterial.new()
var mainMaterial = preload("res://assets/geometry/article/key/Key.material")
onready var UI = get_tree().get_current_scene().get_node(str(Globals.scenename,"/UI"))
onready var bottom_info = str(Language.get(keyName)," ",Language.get("key"))

func _ready():
	
	# buradaki sinyallerı hangi event yayınlıyor ? 
	Globals.connect("_on_aim_entered",self,"_on_aim_entered")
	Globals.connect("_on_aim_exited",self,"_on_aim_exited")
	
	var next_pass = preload("res://assets/material_shader/key_outline.material")
	
	outlineMaterial = mainMaterial.duplicate()
	outlineMaterial.set_next_pass(next_pass)

func _on_aim_entered(body):
	if body == self:
		$Key2.set_surface_material(0,outlineMaterial)
		UI.set_bottom_info(bottom_info)

func _on_aim_exited(body):
	if body == self:
		$Key2.set_surface_material(0,mainMaterial)
		UI.set_bottom_info("")
		
func _input(event):
	if Input.is_action_just_pressed("pickUp"):
		if Globals.getAimObject() == self:
			Globals.ownedKeys.append(keyId)
			rpc("getKey")
			UI.set_bottom_info("")

remotesync func getKey():
	queue_free()


