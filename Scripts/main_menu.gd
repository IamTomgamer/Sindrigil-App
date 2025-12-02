extends Node2D

@onready var grid = $Menu/ScrollContainer/GridContainer
var card_scene = preload("res://Cards/Stocked_Item.tscn")

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			load_items("user://stocked")
			# Do your action here

func _ready():
	load_items("user://stocked")

func load_items(base_path: String) -> void:
	for child in grid.get_children():
		child.queue_free()
	if not DirAccess.dir_exists_absolute(base_path):
		DirAccess.make_dir_recursive_absolute(base_path)

	var dir = DirAccess.open(base_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var item_path = base_path + "/" + file_name + "/item.json"
				if FileAccess.file_exists(item_path):
					var data = load_json(item_path)
					if data:
						# Add the folder path so the card knows where to look
						data["__folder"] = base_path + "/" + file_name

						var card = card_scene.instantiate()
						grid.add_child(card)        # ensure onready vars are ready
						card.set_data(data)
			file_name = dir.get_next()
		dir.list_dir_end()

		
func load_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		return JSON.parse_string(text)
	return {}


func _on_custom_items_button_pressed() -> void:
	Global.CustomItemsScreen()
