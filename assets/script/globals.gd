#----------- Globals.gd ------------#

#This script is included in autoload, 
#"Globals." It can be used in other scripts using.
#-----------------------------------#


extends Node

var playerId

var language


#The "scenename" that will be placed under the game object where the network is installed. 
#get_tree().get_current_scene().get_node(str("Globals.scenename", "node name"))

var scenename = "demo_scene"

var scene = preload("res://assets/scene/demo_scene.tscn").instance()

var flashLight = true

#It is the data that will go to game.gd. 
#game.gd takes this data and creates a server or client according to its type.
#The reason it is 2 at the beginning is not equal to any value.
#0 = Server / 1 = Client

var userType = 2 

var playerCount = 0
var joinIp = "127.0.0.1"

# array for keys in the inventory
var ownedKeys = []
# default message in key list we need to assign a value in language.
var key_Message = "No_key"

#The signal is sent here from the player_movement.gd script. 
#These signals can be connect to other scripts.
#Example:

#Globals.connect ("_ on_aim_entered", self, "_ on_aim_entered")
#Globals.connect ("_ on_aim_exited", self, "_ on_aim_exited")

signal _on_aim_entered(body)
signal _on_aim_exited(body)



#Function that returns the object that the player's (player_movement.gd) aim raycast corresponds to.
#Example:
#if Globals.getAimObject == get_node("staticbody or rigidbody or kinematicbody etc."):

#If the player was created on the stage and her ID is the client's network ID (playerId), 
#the object that the raycast coincides with is taken.

func getAimObject() -> Object:
	if get_tree().get_current_scene().has_node(str(scenename,"/",playerId)):
		var raycast = get_tree().current_scene.get_node(str(scenename,"/",playerId,"/pivot/Aim"))
		if raycast.is_colliding():
			return raycast.get_collider()
		else:
			return null
	else:
		return null

# indexing keys we have
func make_Array_Key_List():
	if ownedKeys.size() > 0 :
		key_Message = ""
		for i in ownedKeys.size():
			var roomName = Language.get(str("room_",ownedKeys[i]))
			key_Message += str(" ",roomName," ",Language.get("key"),"\n")
