extends Panel

var initial_mouse_pos = Vector2()
var entry_box = preload("res://Scene/entry_box.tscn")
var edit_entry_box = preload("res://Scene/edit_entry_box.tscn")
var text_changed = false
var new_created = false

func _ready():
	Global.new_budget = true
	Events.get_entries.connect(get_entries)
	Events.calculate.connect(calculate_values)

func calculate_values():
	var credits = []
	var debits = []

	if Global.current != null and Global.current != {}:
		var firstkey = Global.current.keys()[0]
		if Global.current.has("credits"):      
			for credit in Global.current["credits"]:
				if credit.has("value"):       
					credits.append(str_to_var(credit["value"]))

		if Global.current.has("debits"):
			for debit in Global.current["debits"]:      
				if debit.has("value"):           
					debits.append(str_to_var(debit["value"]))

	var total_income = Mathdoer.calculate_income(credits)
	var total_expenses = Mathdoer.calculate_expenses(debits)
	var savings = total_income - total_expenses

	$InfoBox/IncValue.text = str(total_income)
	$InfoBox/ExpValue.text = str(total_expenses)
	$InfoBox/SavValue.text = str(savings)

func _on_save_timer_timeout():
	calculate_values()

func _on_button_pressed():
	if $Title.text == "":
		$"Control/Exclamation Title".play("default")
		$"Control/Exclamation Title".show()
		return
	$"Control/Exclamation Title".hide()
	var credits = []
	var debits = []
	if Global.new_budget:
		GlobalEngine.create_budget($Title.text, $InfoBox/IncValue.text, $InfoBox/ExpValue.text, $InfoBox/SavValue.text, credits, debits)
		Global.new_budget = false
	else:
		GlobalEngine.edit_budget($Title.text, $InfoBox/IncValue.text, $InfoBox/ExpValue.text, $InfoBox/SavValue.text)
	var instance = entry_box.instantiate()
	add_child(instance)

func get_entries():
	$EntryBox.clear()
	$EntryBox2.clear()
	$Ids.clear()
	var entryData = Global.current
	if entryData["credits"].size() > 0:
		for credit in entryData["credits"]:
			#var plusTexture = load("res://Assets/UI/Plus.png")
			#var plusIcon = ImageTexture.new()
			#plusIcon.set_image(plusTexture)
			$EntryBox.add_item(credit["title"] + " - Credit")
			$EntryBox2.add_item(credit["value"])
			$Ids.add_item(credit["id"])
			
	if entryData["debits"].size() > 0:
		for debit in entryData["debits"]:
			#var minusTexture = load("res://Assets/UI/Minus.png")
			#var minusIcon = ImageTexture.new()
			#minusIcon.set_image(minusTexture)
			$EntryBox.add_item(debit["title"] + " - Debit")
			$EntryBox2.add_item(debit["value"])
			$Ids.add_item(debit["id"])

func _on_button_2_pressed():
	Events.emit_signal("load_saved_budgets")
	queue_free()

func _on_accept_dialog_confirmed():
	$AcceptDialog.hide()

func _on_entry_box_item_clicked(index, at_position, mouse_button_index):
	var instance = edit_entry_box.instantiate()
	add_child(instance)
	Events.emit_signal("edit_entry", $Ids.get_item_text(index))

func _on_Control_mouse_entered():
	initial_mouse_pos = get_local_mouse_position()
	
func _on_Control_mouse_motion():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var current_pos = get_local_mouse_position()
		var delta = initial_mouse_pos - current_pos
		var scroll_container = get_node("ScrollContainer")
		scroll_container.scroll_vertical += delta.y
