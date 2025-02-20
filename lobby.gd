extends "res://sub_menu.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("LOBBY is _ready()")
	$MarginContainer/VBoxContainer/StatusRichTextLabel.text = 'Waiting for players...'
	$MarginContainer/VBoxContainer/SendChatContainer/ChatInput.grab_focus()

# Called every frame. "delta" is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
