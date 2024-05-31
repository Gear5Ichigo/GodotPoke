extends Control

signal player_connected(peer_id, player_info)
signal server_disconnected

signal padd

const PORT = 10523
@onready var target_ip = get_node("MainContainer/ProcessingSection/TargetIp")
@onready var playername = get_node("MainContainer/PlayerName").text

var players = GameManager.Players

@rpc("any_peer", "reliable")
func _register_player(info):
	var unique_id = multiplayer.get_remote_sender_id()
	players[unique_id] = {"name":info}
	player_connected.emit(unique_id, info)

@rpc("any_peer", "reliable")
func toggleProccessButtons():
	var ps = get_node("MainContainer/ProcessingSection").get_children()
	var pc = get_node("PeopleContainer").get_children()
	for child in ps:
		child.visible = !child.visible
	for child in pc:
		child.visible = !child.visible
	get_node("MainContainer/PlayerName").editable = !get_node("MainContainer/PlayerName").editable

##
func _on_player_connected(id): # affects all clients
	print("player "+str(id)+" joined")
	_register_player.rpc_id(id, playername)
	padd.emit()

func _on_player_disconnected(id):
	pass

func _on_connected_ok(): #client sided/local
	var unique_id = multiplayer.get_unique_id()
	players[unique_id] = {"name":playername}
	player_connected.emit(unique_id, "asd")
	
	
func _on_connected_fail():
	multiplayer.multiplayer_peer = null
	print("server connection fail")
	
func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	
##

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 4)
	if error: return  error
	multiplayer.multiplayer_peer = peer
	
	players[1] = {"name":playername}
	player_connected.emit(1, {"name":playername})
	

func _on_join_pressed():
	var address = target_ip.text
	if address.is_empty():
		return
	print(address)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error: return error
	multiplayer.multiplayer_peer = peer

func _on_leave_pressed():
	_on_server_disconnected()
	server_disconnected.emit()
