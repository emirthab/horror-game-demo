extends Node

var key
var kitchen
var room


var config
var err

func _ready():
	loadLangs()

# lokalizasyon için variable ları belirtilen text dosyasındaki karşılıkları ile değiltiriyor.
func loadLangs():
	config = ConfigFile.new()
	err = config.load(str("res://languages/",Globals.language,".cfg"))
	if err == OK:

		print("OKKK")
		key = config.get_value("lang","key")
		kitchen = config.get_value("lang","kitchen")
		room = config.get_value("lang","room")
