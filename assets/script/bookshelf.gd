# --------- Bookshelf - System -------- #
#When the player enters the game and the if player is host, 
#a secretBook objects are identified randomly from the books on bookshelf object.

#SecretBook definition is defined by the server with the rpc method ,
#to the secretBook variable in the client that connects to the game 
#when a client connects to the game. 
#look --> "_player_connected" function

#When the correct book (secretBook variable) is focused and the "pickUp" button is pressed,
#the bookshelf rotates with animations. (on the all client)
# -------------------------------- #

extends Spatial

var openTimer = Timer.new()
var closeTimer = Timer.new()

var open = false

var secretBook



func _ready():
	get_tree().connect("network_peer_connected",self,"_player_connected")
	if Globals.playerId == 1:
		assignSecretBook()

	#Timer assigns
	#Bookshelf opening cast time
	openTimer.wait_time = 1.0
	openTimer.connect("timeout",self,"_openTimerTimeOut") 
	openTimer.one_shot = true
	add_child(openTimer)

	#Bookshelf closing cooldown
	closeTimer.wait_time = 5.5
	closeTimer.connect("timeout",self,"_closeTimerTimeOut") 
	closeTimer.one_shot = true
	add_child(closeTimer)


#When the appropriate conditions are met, 
#bookshelf opening function is triggered with rpc. (on all clients)
func _input(event):
	if Input.is_action_just_pressed("pickUp"):
		if Globals.getAimObject() == get_node(str("BOOKS/",secretBook,"/StaticBody")) && open == false:
			if $AnimationPlayer.is_playing() == false:
				rpc("openBookshelf")


#triggers the start of library open events (including shutdown) on all clients.
remotesync func openBookshelf():
	get_node(str("BOOKS/",secretBook,"/AnimationPlayer")).play("push")
	openTimer.start()
	open = true


#opening animations
func _openTimerTimeOut():
	$AnimationPlayer.play("rotate_1")
	closeTimer.start()

#closing animations
func _closeTimerTimeOut():
	open = false
	$AnimationPlayer.play("rotate_2")
	get_node(str("BOOKS/",secretBook,"/AnimationPlayer")).play("pull")


#if player is host (network id=1), secretBook variable is randomly defined.
func assignSecretBook():
	var count = $BOOKS.get_child_count()
	randomize()
	var secretIndex = randi() %count
	secretBook = $BOOKS.get_child(secretIndex).name
	
	#For debug
	changeMaterial()


#when new player connected, secretBook variable assigned by host player to new player.
func _player_connected(id):
	if Globals.playerId == 1:
		rpc("setSecretBook",secretBook)


remote func setSecretBook(variable):
	secretBook = variable
	changeMaterial()



# ! FOR DEBUG !
#change secretBook material
func changeMaterial():

	var mat = preload("res://assets/material_shader/debug_secret_book.material")
	var index = $BOOKS.get_node(secretBook)
	
	for i in index.get_child_count():
		
		var child = index.get_child(i)

		if child.get_class() == "MeshInstance":
			child.set_surface_material(0,mat)

		for n in child.get_child_count():
			var child2 = child.get_child(n)
			
			if child2.get_class() == "MeshInstance":
				child2.set_surface_material(0,mat)
			
			for a in child2.get_child_count():
				var child3 = child2.get_child(a)
				if child3.get_class() == "MeshInstance":
					child3.set_surface_material(0,mat)
					
				for c in child3.get_child_count():
					var child4 = child3.get_child(a)
					if child4.get_class() == "MeshInstance":
						child4.set_surface_material(0,mat)
