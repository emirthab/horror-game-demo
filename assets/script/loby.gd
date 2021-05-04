extends Control

func _ready():
	$HTTPRequest.request("https://api.ipify.org")

func _on_Create_Server_pressed():
	#usertype 0 for Server
	Globals.userType = 0
	var scene = "res://assets/scene/demo_scene.tscn"
	get_tree().change_scene(scene)

func _on_Join_Server_pressed():
	#usertype 1 for Client
	Globals.joinIp = $Multiplayer_Configure/join_ip.text
	Globals.userType = 1
	var scene = "res://assets/scene/demo_scene.tscn"
	get_tree().change_scene(scene)

func _player_connected():
	pass
	
func _player_disconnected():
	pass


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$Multiplayer_Configure/device_ip.set_text(str(body.get_string_from_utf8()))
