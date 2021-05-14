extends Spatial

var scene = preload("res://assets/scene/demo_scene.tscn").instance()

# oyuncu bağlanınca yayınlanan signal leri bağlamış 

func _ready():
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")

	#if server
	if Globals.userType == 0:
		multiplayerCreate("server")
	#if client
	else:
		multiplayerCreate("client")



func multiplayerCreate(type):
	
	#Create Enet based networking object.
	
	var net = NetworkedMultiplayerENet.new()
	var player = load("res://assets/sprite/player.tscn").instance()
	
	#create server or client, players network master and name set to id.
	#players position set 
	if type == "server":
		net.create_server(6969,10)
		get_tree().set_network_peer(net)
		print("host başlatılıyor...")
		var id = get_tree().get_network_unique_id()
		Globals.playerId = id
		add_child(scene)
		player.set_name(str(id))
		player.set_network_master(id)
		player.global_transform = $demo_scene/playerPosition.global_transform
		$demo_scene.add_child(player)

	elif type == "client":
		#ip set to join_ip input
		var ip = str(Globals.joinIp)
		print(ip)
		net.create_client(ip,6969)
		get_tree().set_network_peer(net)
		var id = get_tree().get_network_unique_id()
		Globals.playerId = id
		add_child(scene)
		player.set_name(str(id))
		player.set_network_master(id)
		player.global_transform = $demo_scene/playerPosition.global_transform
		$demo_scene.add_child(player)
		
	addPlayerCount(1)


# oyuncu bağlanınca çalışan fonksiyon
func _player_connected(id):
	createPlayer(id)
	addPlayerCount(1)

# oyuncu kopunca çalışan fonksiyon
func _player_disconnected(id):
	$demo_scene.get_node(str(id)).queue_free()
	downPlayerCount(1)

# menude gösterilen oyuncu sayısını artıran foksiyon
remotesync func addPlayerCount(size):
	Globals.playerCount += size
# menude gösterilen oyuncu sayısını artıran foksiyon	
remotesync func downPlayerCount(size):
	Globals.playerCount -= size


#When player connected to server, create player on $playerPosition.
func createPlayer(id):
	var player = load("res://assets/sprite/puppet_player.tscn").instance()
	player.set_name(str(id))
	player.set_network_master(id)
	player.global_transform = $demo_scene/playerPosition.global_transform
	print("oyuncu baglandi ", id)
	$demo_scene.add_child(player)
