extends Control

func _ready():
	languageItems()
	$HTTPRequest.request("https://api.ipify.org")

func _on_Create_Server_pressed():
	#usertype 0 for Server
	Globals.userType = 0
	var scene = "res://assets/scene/game.tscn"
	get_tree().change_scene(scene)
	var lang = str($language.get_item_text($language.get_item_index($language.get_selected_id())))
	lang = lang.replace(" ","")
	Globals.language = lang
	Language.loadLangs()

func _on_Join_Server_pressed():
	#usertype 1 for Client
	Globals.joinIp = $Multiplayer_Configure/join_ip.text
	Globals.userType = 1
	var scene = "res://assets/scene/game.tscn"
	get_tree().change_scene(scene)
	var lang = str($language.get_item_text($language.get_item_index($language.get_selected_id())))
	lang = lang.replace(" ","")
	Globals.language = lang
	Language.loadLangs()

#Get device ip adress
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	$Multiplayer_Configure/device_ip.set_text(str(body.get_string_from_utf8()))

#menu dilini ayarlıyor
func languageItems():
	var path = "res://languages/"
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && file.ends_with(".cfg"):
			file = file.replace(".cfg","")
			$language.add_item(file)
	dir.list_dir_end()


func _on_language_item_selected(index):
	Globals.language = str(index)
