extends "res://sub_menu.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("HOST MENU is _ready()")
	load_server_config()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func generate_server_name():
	const server_names_articles = ["", "The", "A", "That", "My", "Your", "Our", "Every"]
	# ... these lists are from deepseek-r1:14b: "give me a list of adjectives/nouns that various game server admins would use to describe their play area."
	const server_names_adjectives = ["Vast", "Detailed", "Immersive", "Expansive", "Intricate", "Dynamic", "Strategic", "Epic", "Engaging", "Vibrant", "Chaotic", "Serene", "Lively", "Desolate", "Hostile", "Dangerous", "Mysterious", "Mystical", "Magical", "Ancient", "Ruined", "Rugged", "Jagged", "Craggy", "Barren", "Frozen", "Scorching", "Lush", "Dense", "Open", "Winding", "Twisting", "Narrow", "Spacious", "Flat", "Hilly", "Mountainous", "Rocky", "Sandy", "Forested", "Jungly", "Swampy", "Marshy", "Urban", "Suburban", "Rural", "Alien", "Futuristic", "Medieval", "Post-Apocalyptic", "Nautical", "Heavenly", "Infernal", "Otherworldly", "Mystical", "Haunted", "Cursed", "Blessed", "Glowing", "Shadowy", "Bright", "Dark", "Eerie", "Spooky", "Creepy", "Cozy", "Warm", "Cold", "Windy", "Rainy", "Sunny", "Cloudy", "Foggy", "Misty", "Snowy", "Rocky", "Sandy", "Muddy", "Dusty", "Rusty", "Metallic", "Wooden", "Stone", "Concrete", "Asphalt", "Grassy", "Mossy", "Floral", "Buggy", "Beastly", "Treacherous", "Unpredictable", "Challenging", "Rewarding", "Balanced", "Unbalanced", "Chaotic", "Orderly", "Mysterious", "Known", "Unknown", "Hidden", "Revealed", "Secret", "Obscure", "Obvious", "Poop"]
	const server_names_nouns = ["Zone", "World", "Battlefield", "Hub", "Base", "Spawn", "Area", "Terrain", "Region", "Stage", "Field", "Grounds", "Enclosure", "Sector", "Quadrant", "Campus", "Battleground", "Playfield", "Arena", "Venue", "Campsite", "Safe Zone", "Wasteland", "Tundra", "Jungle", "Desert", "Forest", "Mountain Range", "River", "Lake", "Ocean", "Island", "City", "Town", "Village", "Castle", "Fortress", "Dungeon", "Cave", "Mine", "Labyrinth", "Maze", "Shrine", "Altar", "Tower", "Keep", "Stronghold", "Ruins", "Hotspot", "Nexus", "Fountain", "Well", "Spring", "Cave", "Tunnel", "Passage", "Portal", "Gate", "Shrine", "Obelisk", "Monolith", "Stone Circle", "Cliff", "Mesa", "Canyon", "Chasm", "Rift", "Volcano", "Asteroid Field", "Space Station", "Planet", "Galaxy", "Sector", "Quadrant", "Nebula", "Black Hole", "Wormhole", "Hyperspace", "Void", "Poop"]
	var art = server_names_articles.pick_random()
	var adj = server_names_adjectives.pick_random()
	var noun = server_names_nouns.pick_random()
	if art == 'A' and adj[0] in 'AEIOU':
		art = 'An'
	return ' '.join([art, adj, noun]).strip_edges()

func save_server_config():
	Options.config.set_value("server", "name", $MarginContainer/VBoxContainer/ServerNameContainer/ServerNameInput.text)
	Options.config.set_value("server", "port", int($MarginContainer/VBoxContainer/PortContainer/PortInput.value))
	Options.config.set_value("server", "upnp", $MarginContainer/VBoxContainer/PortContainer/UPnPCheckBox.button_pressed)
	if $MarginContainer/VBoxContainer/VisibilityContainer/VisibilityList.get_selected_items():
		var selected_item_id = $MarginContainer/VBoxContainer/VisibilityContainer/VisibilityList.get_selected_items()[0]
		Options.config.set_value("server", "visibility", $MarginContainer/VBoxContainer/VisibilityContainer/VisibilityList.get_item_text(selected_item_id))
	if $MarginContainer/VBoxContainer/GameContainer/GameList.get_selected_items():
		var selected_item_id = $MarginContainer/VBoxContainer/GameContainer/GameList.get_selected_items()[0]
		Options.config.set_value("server", "game", $MarginContainer/VBoxContainer/GameContainer/GameList.get_item_text(selected_item_id))
	Options.config.set_value("server", "max_players", int($MarginContainer/VBoxContainer/MaxPlayersContainer/MaxPlayersInput.value))
	Options.save_config()
	
func load_server_config():
	# Load saved settings:
	if Options.config.get_value("server", "port"):
		$MarginContainer/VBoxContainer/ServerNameContainer/ServerNameInput.text = Options.config.get_value("server", "name")
		$MarginContainer/VBoxContainer/PortContainer/PortInput.value = Options.config.get_value("server", "port")
		$MarginContainer/VBoxContainer/PortContainer/UPnPCheckBox.button_pressed = Options.config.get_value("server", "upnp")
		var visibility = Options.config.get_value("server", "visibility")
		if len(visibility):
			for item_id in $MarginContainer/VBoxContainer/VisibilityContainer/VisibilityList.get_item_count():
				var item_text = $MarginContainer/VBoxContainer/VisibilityContainer/VisibilityList.get_item_text(item_id)
				if item_text == visibility:
					$MarginContainer/VBoxContainer/VisibilityContainer/VisibilityList.select(item_id)
		var game = Options.config.get_value("server", "game")
		if len(game):
			for item_id in $MarginContainer/VBoxContainer/GameContainer/GameList.get_item_count():
				var item_text = $MarginContainer/VBoxContainer/GameContainer/GameList.get_item_text(item_id)
				if item_text == game:
					$MarginContainer/VBoxContainer/GameContainer/GameList.select(item_id)
		$MarginContainer/VBoxContainer/MaxPlayersContainer/MaxPlayersInput.value = Options.config.get_value("server", "max_players")
		
	# Set default values:
	else:
		# Random server name
		$MarginContainer/VBoxContainer/ServerNameContainer/ServerNameInput.text = generate_server_name()
		# Select first list items by default
		$MarginContainer/VBoxContainer/VisibilityContainer/VisibilityList.select(0)
		$MarginContainer/VBoxContainer/GameContainer/GameList.select(0)
		
var peer = ENetMultiplayerPeer.new()

func start_server(port, max_clients):
	peer.create_server(port, max_clients)
	multiplayer.multiplayer_peer = peer

var upnp = UPNP.new()

func stop_server():
	if $MarginContainer/VBoxContainer/PortContainer/UPnPCheckBox.button_pressed:
		upnp.delete_port_mapping($MarginContainer/VBoxContainer/PortContainer/PortInput.value)

func _on_start_server_button_pressed():
	save_server_config()
	var port : int = $MarginContainer/VBoxContainer/PortContainer/PortInput.value
	var max_clients : int = $MarginContainer/VBoxContainer/MaxPlayersContainer/MaxPlayersInput.value
	start_server(port, max_clients)
	get_tree().change_scene_to_file("res://lobby.tscn")
	if $MarginContainer/VBoxContainer/PortContainer/UPnPCheckBox.button_pressed:
		# @todo this blocks for a few seconds, use Threads instead https://docs.godotengine.org/en/stable/classes/class_upnp.html
		upnp.discover()
		upnp.add_port_mapping(port)


func _on_randomize_button_pressed() -> void:
	$MarginContainer/VBoxContainer/ServerNameContainer/ServerNameInput.text = generate_server_name()
