extends Control

@onready var image_rect    = $VBoxContainer/Image
@onready var name_label    = $VBoxContainer/HBoxContainer/Name
@onready var number_label  = $VBoxContainer/HBoxContainer2/Number
@onready var Less_Stocked  = $VBoxContainer/HBoxContainer2/Less
@onready var More_stocked  = $VBoxContainer/HBoxContainer2/More

var data : Dictionary = {}
var folder_path : String = ""
signal amount_changed(new_amount)
func _ready():
	print(name_label)

func set_data(setdata: Dictionary) -> void:
	# Store dictionary and folder path for later use
	data = setdata
	folder_path = setdata.get("__folder", "")

	# Update UI
	name_label.text = setdata.get("name", "Unknown")
	number_label.text = str(int(setdata.get("amount", 0)))

	# Build path to item.png
	if folder_path != "":
		var img_path = folder_path + "/item.png"
		if FileAccess.file_exists(img_path):
			var img = Image.new()
			if img.load(img_path) == OK:
				var tex = ImageTexture.new()
				tex.set_image(img)
				image_rect.texture = tex
			else:
				print("Failed to load image:", img_path)
		else:
			print("Missing image:", img_path)

func _on_texture_button_pressed() -> void:
	print("button pressed")

func _on_less_pressed() -> void:
	# Decrement amount
	var amount = int(data.get("amount", 0)) - 1
	data["amount"] = amount
	if amount < 0:
		data["amount"] = 0
		amount = 0
		number_label.text = str(amount)

	# Update UI
	number_label.text = str(amount)

	# Save back to JSON
	if folder_path != "":
		var item_path = folder_path + "/item.json"
		var file = FileAccess.open(item_path, FileAccess.WRITE)
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("Saved new amount:", amount, "to", item_path)
	emit_signal("amount_changed", amount)

func _on_more_pressed() -> void:
	# Increment amount
	var amount = int(data.get("amount", 0)) + 1
	data["amount"] = amount
	if amount < 0:
		data["amount"] = 0
		amount = 0
		number_label.text = str(amount)

	# Update UI
	number_label.text = str(amount)

	# Save back to JSON
	if folder_path != "":
		var item_path = folder_path + "/item.json"
		var file = FileAccess.open(item_path, FileAccess.WRITE)
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("Saved new amount:", amount, "to", item_path)
	emit_signal("amount_changed", amount)
