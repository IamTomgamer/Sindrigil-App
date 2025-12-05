extends Control

@onready var Productname = $VBoxContainer/ScrollContainer/VBoxContainer/productname
@onready var Clientname = $VBoxContainer/ScrollContainer/VBoxContainer/clientname

func _on_button_pressed() -> void:
	if Productname.text == "":
		push_error("Product does not have a name")
	else:
		save_item(Productname, Clientname)


	if Clientname.text == "":
		push_error("Client does not have a name")
	else:
		save_item(Productname, Clientname)
	get_tree().change_scene_to_file("res://Menu's/Custom Items.tscn")
	
		# Save the item and get the folder path
	var folder_path = save_item(Productname, Clientname)
	
	# Open the folder in the OS file manager
	OS.shell_open(ProjectSettings.globalize_path(folder_path))
func save_item(product_name_node: LineEdit, client_name_node: LineEdit) -> String:
	var base_path = "user://custom"
	var folder_name = product_name_node.text.strip_edges()
	var folder_path = base_path + "/" + folder_name
	
	# Ensure folder exists
	DirAccess.make_dir_recursive_absolute(folder_path)
	
	# Save JSON
	var item_data = {
		"name": product_name_node.text,
		"client": client_name_node.text,
		"finished": 0
	}
	var file_path = folder_path + "/item.json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(item_data, "\t"))
		file.close()
	
	# Return the folder path so caller can use it
	return folder_path


func _on_home_button_pressed() -> void:
	Global.CustomItemsScreen()
