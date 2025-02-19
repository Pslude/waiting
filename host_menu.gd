extends "res://sub_menu.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("HOST MENU is _ready()")
	load_server_config()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func save_server_config():
	Options.config.set_value("server", "name", $MarginContainer/VBoxContainer/ServerNameInput.text)
	Options.config.set_value("server", "port", $MarginContainer/VBoxContainer/HBoxContainer/PortInput.value)
	Options.config.set_value("server", "upnp", $MarginContainer/VBoxContainer/HBoxContainer/UPnPCheckBox.button_pressed)
	Options.config.set_value("server", "max_players", $MarginContainer/VBoxContainer/MaxPlayersInput.value)
	Options.save_config()
	
func load_server_config():
	if Options.config.get_value("server", "port"):
		$MarginContainer/VBoxContainer/ServerNameInput.text = Options.config.get_value("server", "name")
		$MarginContainer/VBoxContainer/HBoxContainer/PortInput.value = Options.config.get_value("server", "port")
		$MarginContainer/VBoxContainer/HBoxContainer/UPnPCheckBox.button_pressed = Options.config.get_value("server", "upnp")
		$MarginContainer/VBoxContainer/MaxPlayersInput.value = Options.config.get_value("server", "max_players")

func start_server():
	var peer = ENetMultiplayerPeer.new()
	var PORT : int = $MarginContainer/VBoxContainer/HBoxContainer/PortInput.value
	var MAX_CLIENTS : int = $MarginContainer/VBoxContainer/MaxPlayersInput.value
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	if $MarginContainer/VBoxContainer/HBoxContainer/UPnPCheckBox.button_pressed:
		# @todo this blocks the thread, use Threads instead (see https://docs.godotengine.org/en/stable/classes/class_upnp.html)
		var upnp = UPNP.new()
		upnp.discover()
		upnp.add_port_mapping(PORT)

#func stop_server():
	#upnp.delete_port_mapping(port)

func _on_start_server_button_pressed():
	save_server_config()
	start_server()
	get_tree().change_scene_to_file("res://lobby.tscn")
