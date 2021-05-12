extends Node

var playerId

var userType = 2 #0 = Server / 1 = Client

var playerCount = 0
var joinIp = "127.0.0.1"

var ownedKeys = []





func raycastTrigger(object) -> bool:
	if get_tree().get_current_scene().has_node(str(playerId)):
		var raycast = get_tree().get_current_scene().get_node(str((playerId),"/pivot/Aim"))
		
		if raycast.is_colliding():
			if raycast.get_collider() == object:
				return true
			else:
				return false
		else:
			return false
	else:
		return false
