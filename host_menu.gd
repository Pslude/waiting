extends "res://sub_menu.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("HOST MENU is _ready()")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_server_button_pressed():
	print('Starting server...')
	var peer = ENetMultiplayerPeer.new()
	
	# @todo get from settings
	var PORT = $MarginContainer/VBoxContainer/PortInput.value
	var MAX_CLIENTS = 32
	
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer

	#_game.add_player(1, _name_edit.text)
	#start_game()
	
	print('Done!')
	get_tree().change_scene_to_file("res://lobby.tscn")
