extends Control

@onready var image_rect     = $HBoxContainer/Image
@onready var name_label     = $HBoxContainer/Name
@onready var client_label     = $HBoxContainer2/Client
@onready var finish_button  = $HBoxContainer/Button
@onready var space = $HBoxContainer2/Space

# Remember the folder path for this card
var folder_path : String = ""

func _ready():
	print(name_label)

func set_data(data: Dictionary) -> void:
	name_label.text = data.get("name", "Unknown")
	client_label.text = data.get("client", "Unknown")

	# Save folder path for later use
	folder_path = data.get("__folder", "")

	# Connect button once
	if not finish_button.pressed.is_connected(_on_finish_pressed):
		finish_button.pressed.connect(_on_finish_pressed)

	# Hide/show button depending on finished flag
	if int(data.get("finished", 0)) == 1:
		finish_button.hide()
		space.hide()
	else:
		finish_button.show()
		space.show()

	# Build path to item.png in the same folder as the JSON
	if folder_path != "":
		var img_path = folder_path + "/item.png"
		if FileAccess.file_exists(img_path):
			var img = Image.new()
			var err = img.load(img_path)
			if err == OK:
				var tex = ImageTexture.new()
				tex.set_image(img)
				image_rect.texture = tex
			else:
				print("Failed to load image:", img_path)
		else:
			print("Missing image:", img_path)

func _on_finish_pressed() -> void:
	var item_path = folder_path + "/item.json"
	if FileAccess.file_exists(item_path):
		var file = FileAccess.open(item_path, FileAccess.READ)
		var text = file.get_as_text()
		file.close()

		var data = JSON.parse_string(text)
		if typeof(data) == TYPE_DICTIONARY:
			data["finished"] = 1

			# Write back to file
			var out = FileAccess.open(item_path, FileAccess.WRITE)
			out.store_string(JSON.stringify(data, "\t")) # pretty print with tabs
			out.close()

			# Update UI immediately
			finish_button.hide()
	get_tree().change_scene_to_file("res://Menu's/Custom Items.tscn")

func _on_texture_button_pressed() -> void:
	print("button pressed")
