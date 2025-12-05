extends Node

var Adminmode = 0

func HomeScreen():
	get_tree().change_scene_to_file("res://Menu's/Main Menu.tscn")
func CustomItemsScreen():
	get_tree().change_scene_to_file("res://Menu's/Custom Items.tscn")
