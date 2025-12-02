extends Control

@onready var image_rect = $VBoxContainer/Image
@onready var name_label = $VBoxContainer/HBoxContainer/Name
@onready var number_label = $VBoxContainer/Number

func _ready():
	print(name_label)
	
func set_data(data: Dictionary) -> void:
	name_label.text = data.get("name", "Unknown")
	number_label.text = str(int(data.get("amount", 0)))

	# Build path to item.png in the same folder as the JSON
	var folder = data.get("__folder", "")
	if folder != "":
		var img_path = folder + "/item.png"
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
	if (data.get("amount") == 0):
		var tex = preload("res://Textures/RedFrame.png")
		$TextureButton.texture_normal = tex
		$TextureButton.texture_pressed = tex
		$TextureButton.texture_hover = tex
	else:
		$TextureButton.texture_normal = null
		$TextureButton.texture_pressed = null
		$TextureButton.texture_hover = null

func _on_texture_button_pressed() -> void:
	print("button pressed")
