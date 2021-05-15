# --------- Key - System -------- #
#When Aim is focused on the key, its outer material changes (outline).

#If the "pickUp" key is pressed while in focus, 
#the key object disappears (on all clients), 
#then the id of the key is added to the Globals.ownedKeys array.

# Look at --> "door.gd" for how to work.
# -------------------------------- #

extends Spatial

export(int) var keyId
onready var keyName = str("room_",keyId)

var outlineMaterial = SpatialMaterial.new()
var mainMaterial = preload("res://assets/geometry/article/key/Key.material")

onready var UI = get_tree().get_current_scene().get_node(str(Globals.scenename,"/UI"))
onready var bottom_info = str(Language.get(keyName)," ",Language.get("key"))

func _ready():

	#Connecting aim signals, Look --> (Globals.gd) for how to work
	Globals.connect("_on_aim_entered",self,"_on_aim_entered")
	Globals.connect("_on_aim_exited",self,"_on_aim_exited")

	var next_pass = preload("res://assets/material_shader/key_outline.material")


	#The material was copied so that it was not included in all keys in the scene.
	#If the outer material was added directly to the object's material, 
	#the outer material of all keys in the scene would change.

	outlineMaterial = mainMaterial.duplicate()
	outlineMaterial.set_next_pass(next_pass)



#Adding outline material when "_on_aim_entered"
#Adding bottom info on screen (ex: Kitchen Key)
func _on_aim_entered(body):
	if body == self:
		$Key2.set_surface_material(0,outlineMaterial)
		UI.set_bottom_info(bottom_info)

#Adding normal material (without outline) when "_on_aim_exited"
#Removing bottom info on screen
func _on_aim_exited(body):
	if body == self:
		$Key2.set_surface_material(0,mainMaterial)
		UI.set_bottom_info("")



#The key id is append to Globals.ownedKeys.
#On all clients, the key is removed from the stage.
func _input(event):
	if Input.is_action_just_pressed("pickUp"):
		if Globals.getAimObject() == self:
			Globals.ownedKeys.append(keyId)
			# indexing keys in the inventory
			Globals.make_Array_Key_List()
			# Rpc function is not working, getKey() funtion never runs			
			rpc("getKey")
			UI.set_bottom_info("")
		
remotesync func getKey():
	queue_free()


