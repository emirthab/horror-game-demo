extends Node

var playerId

var language

var flashLight = true

var userType = 2 #0 = Server / 1 = Client

var playerCount = 0
var joinIp = "127.0.0.1"

var ownedKeys = []

signal _on_aim_entered(body)
signal _on_aim_exited(body)

func getAimObject() -> Object:
	if get_tree().get_current_scene().has_node(str(playerId)):
		var raycast = get_tree().get_current_scene().get_node(str((playerId),"/pivot/Aim"))
		
		if raycast.is_colliding():
			return raycast.get_collider()
		else:
			return null
	else:
		return null
		

