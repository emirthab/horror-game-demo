# --------- Language - System -------- #
#This script is included in autoload, 
#"Language.<variableName>" It can be used in other scripts using.

#All files with cfg extension in the Languages file are 
#scanned and imported to game as language option.

#All variables (key name, item name, etc.) with localization feature that 
#the player can see from other scripts will be pulled from here.
#Example: look --> "bottom_info" variable on "key.gd"
# -------------------------------- #


extends Node

var key
var room_0
var room_1
var room


var config
var err

func _ready():
	loadLangs()

func loadLangs():
	config = ConfigFile.new()
	err = config.load(str("res://languages/",Globals.language,".cfg"))
	if err == OK:

		print("OKKK")
		key = config.get_value("lang","key")
		room_0 = config.get_value("lang","room_0")
		room_1 = config.get_value("lang","room_1")
		room = config.get_value("lang","room")
