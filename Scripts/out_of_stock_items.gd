extends Control


@onready var name_label    = $HBoxContainer/Label

func _ready():
	print(name_label)

func set_data(setdata: Dictionary) -> void:

	# Update UI
	name_label.text = str(setdata.get("name", "Unknown")) + "\nIs Out Of Stock"
