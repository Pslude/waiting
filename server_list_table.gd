extends "res://table.gd"

func Render():
	if data:
		var column_headers = [
			'Server Name',
			'Ping',
			'Location',
			'Region',
			'Status',
			'Country',
		]
		var column_keys = [
			'name',
			'last_ping_latency',
			'location',
			'region',
			'status',
			'country',
		]
		# print(data[0].keys())
		# ["url", "id", "name", "location", "region", "country", "host_name", "port", "ipv4", "ipv6", "status", "last_ping", "last_ping_latency"]
		var cols_row = TableRow.instantiate()
		for col in column_headers:
			var cell = TableHeaderCell.instantiate()
			cell.text = col
			cols_row.add_child(cell)
			cell.pressed.connect(_on_header_clicked.bind(col))
		$Rows.add_child(cols_row)
	
		var actions_header_cell = TableHeaderCell.instantiate()
		actions_header_cell.text = ''
		cols_row.add_child(actions_header_cell)
	
		for row_data in data:
			var row = TableRow.instantiate()
			$Rows.add_child(row)
			
			#for key in row_data:
				#var cell = TableCell.instantiate()
				#cell.text = str(row_data[key])
				#row.add_child(cell)
				
			for col_key in column_keys:
				var cell = TableCell.instantiate()
				cell.text = str(row_data[col_key])
				row.add_child(cell)

			var actions_cell = TableRowButton.instantiate()
			actions_cell.text = str('Join Game')
			row.add_child(actions_cell)
			actions_cell.pressed.connect(_on_actions_clicked.bind(row_data))

func _on_actions_clicked(row_data):
	print("ActionsClik: ", row_data)
	get_tree().change_scene_to_file("res://lobby.tscn")
