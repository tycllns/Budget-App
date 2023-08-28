extends Panel

var edit_page = preload("res://Scene/edit_budget_page.tscn")
var budget_page = preload("res://Scene/edit_budget_page.tscn")
var chart_page = preload("res://Scene/charting.tscn")
var sparkles = preload("res://Effects/sparkles.tscn")

func _ready():
	load_budgets()
	$AnimationPlayer.play("Logo Pop")
	Events.load_saved_budgets.connect(load_budgets)

func _on_new_pressed():
	#var instance = sparkles.instantiate()
	#add_child(instance)
	
	#instance.global_position = get_global_mouse_position()
	#instance.emitting = true
	$TitleCreator.popup_centered()
	$TitleCreator/VBoxContainer/HBoxContainer/Confirm.pressed.connect(_on_new_confirmed)
	$TitleCreator/VBoxContainer/HBoxContainer/Cancel.pressed.connect(_on_cancelled)

func _on_new_confirmed():
	GlobalEngine.create_budget($TitleCreator/VBoxContainer/Title.text, "0", "0", "0", [], [])
	var instance = edit_page.instantiate()
	add_child(instance)
	$TitleCreator.hide()

func _on_cancelled():
	$TitleCreator/VBoxContainer/Title.clear()
	$TitleCreator.hide()

func _on_open_pressed():
	$Load.popup_centered()

func _on_back_pressed():
	$Load.hide()

func _on_load_open_pressed():
	var cur 
	for entry in Global.data:
		if $Load/Ids.get_item_text($Load/Panel/ItemList.get_selected_items()[0]) == entry["id"]:
			cur = entry
	GlobalEngine.set_current(cur)
	var instance = edit_page.instantiate()
	add_child(instance)
	$Load.hide()

func _on_load_delete_pressed():
	GlobalEngine.delete_budget($Load/Ids.get_item_text($Load/Panel/ItemList.get_selected_items()[0]))
	Events.emit_signal("load_saved_budgets")
	
func load_budgets():
	$Load/Panel/ItemList.clear()
	$Load/Ids.clear()
	for item in Global.data:
		$Load/Panel/ItemList.add_item(item["title"])
		$Load/Ids.add_item(item["id"])

func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	pass

func _on_charts_pressed():
	var instance = chart_page.instantiate()
	add_child(instance)


func _on_delete_pressed():
	pass # Replace with function body.
