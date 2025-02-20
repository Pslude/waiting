extends "res://sub_menu.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("JOIN MENU is _ready()")
	
	$MarginContainer/VBoxContainer/StatusRichTextLabel.text = 'Finding servers...'
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	var http_error = http_request.request("https://tabarnak.app/host/api/servers/?format=json&game_mode__game__name=Waiting&game_mode__name=Sandbox&release__name=0.0.1&status=a")
	if http_error != OK:
		push_error("An error occurred in the HTTP request.")
	
func update_server_list(servers):
	# print(servers)
	$MarginContainer/VBoxContainer/ServerListPanel/ServerListTable.data = servers
	$MarginContainer/VBoxContainer/ServerListPanel/ServerListTable.Render()
	# @ref https://youtu.be/kM329STAi80?t=622
	
# Called when the HTTP request is completed.
func _http_request_completed(_result, response_code, _headers, body):
	
	if response_code != 200:
		OS.alert("Server responded with HTTP Error %d." % response_code, "Server Error")
		get_tree().change_scene_to_file("res://main_menu.tscn")
		
	var body_as_string = body.get_string_from_utf8()
	if body_as_string == "":
		OS.alert("No content in server response.", "Server Error")
		get_tree().change_scene_to_file("res://main_menu.tscn")
	
	var json = JSON.new()
	json.parse(body_as_string)
	var body_data = json.get_data()
	
	if not body_data:
		OS.alert("Server response does not contain JSON data.", "Server Error")
		get_tree().change_scene_to_file("res://main_menu.tscn")
	
	if "results" not in body_data:
		OS.alert("Server response does not contain 'results' in JSON data.", "Server Error")
		get_tree().change_scene_to_file("res://main_menu.tscn")

	$MarginContainer/VBoxContainer/StatusRichTextLabel.text = \
	  ("%d server found." if body_data["count"] == 1 else "%d servers found.") \
	 % body_data["count"]
	update_server_list(body_data["results"])
	
	
# Called every frame. "delta" is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
