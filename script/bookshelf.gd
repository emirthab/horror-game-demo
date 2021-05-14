extends Spatial


# timer variable ları tanımlarken bence daha açık isimlendirmeler kullanılmalı
#  birini BookShelfOpenTimer diğerini BookshelfCloseTimer diye isimlendirince aşağıdaki commentlere gerek kalmıyor
var timer = Timer.new()
var timer2 = Timer.new()

var open = false

var secretBook


func _ready():
	get_tree().connect("network_peer_connected",self,"_player_connected")
	if Globals.playerId == 1:
		assignSecretBook()


	#Bookshelf opening cast time
	timer.wait_time = 1.0
	timer.connect("timeout",self,"timeout") 
	timer.one_shot = true
	add_child(timer)

	#Bookshelf closing cooldown
	timer2.wait_time = 5.5
	timer2.connect("timeout",self,"timeout2") 
	timer2.one_shot = true
	add_child(timer2)

# oyuncu komutunu yorumlayan fonksiyon	
func _input(event):
	if Input.is_action_just_pressed("pickUp"):
		if Globals.getAimObject() == get_node(str("BOOKS/",secretBook,"/StaticBody")) && open == false:
			if $AnimationPlayer.is_playing() == false:
				rpc("openBookshelf")
	

remotesync func openBookshelf():
	get_node(str("BOOKS/",secretBook,"/AnimationPlayer")).play("push")
	timer.start()
	open = true

func timeout():
	$AnimationPlayer.play("rotate_1")
	timer2.start()
	
func timeout2():
	open = false
	$AnimationPlayer.play("rotate_2")
	get_node(str("BOOKS/",secretBook,"/AnimationPlayer")).play("pull")


func assignSecretBook():
	var count = $BOOKS.get_child_count()
	randomize()
	var secretIndex = randi() %count
	secretBook = $BOOKS.get_child(secretIndex).name
	
	changeMaterial()

# oyuncu bağlandığında secretbook un tipini değiştiriyor lakimn assignSecretbook dan farkını anlayamadım
# yada neden rpc fonsiyonunu kullandık direk setSecretBook u kullanmadık.
func _player_connected(id):
	if Globals.playerId == 1:
		rpc("setSecretBook",secretBook)


remote func setSecretBook(variable):
	secretBook = variable
	changeMaterial()



# ! FOR DEBUG !
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
