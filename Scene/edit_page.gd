extends Panel

var entry_box = preload("res://Scene/entry_box.tscn")
var edit_entry_box = preload("res://Scene/edit_entry_box.tscn")
var pop_up_text = preload("res://Effects/pop_up_text.tscn")

var title = ""
var entry_ids = []
var initial_mouse_pos = Vector2()
@onready var item_list_1 = $EntryBox.get_v_scroll_bar()# Replace with the path to your first ItemList node
@onready var item_list_2 = $EntryBox2.get_v_scroll_bar() # Replace with the path to your second ItemList node

func _ready():
	set_process_input(true)
	Events.pop_up_text.connect(pop_text)
	Events.get_entries.connect(get_entries)
	$Title.text = Global.current["title"]
	get_entries()
	Events.calculate.connect(calculate_values)
	item_list_1.value_changed.connect(_on_item_list_scrolled)

func _on_item_list_scrolled(event):
	item_list_2.value = item_list_1.value

func calculate_values():
	var credits = []
	var debits = []
	if Global.current != null:
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
	Global.current["income"] = total_income
	Global.current["expenses"] = total_expenses
	Global.current["savings"] = savings
	var exppercent = Mathdoer.calculate_percentage(total_expenses,total_income)
	var savpercent = Mathdoer.calculate_percentage(savings,total_income)
	$VBoxContainer/exppercent.text = str(exppercent)
	$VBoxContainer/savpercent.text = str(savpercent)
	$InfoBox/IncValue.text = str(total_income)
	$InfoBox/ExpValue.text = str(total_expenses)
	$InfoBox/SavValue.text = str(savings)
	Global.save()

func _on_save_timer_timeout():
	calculate_values()
	item_list_2.visible = false

func _on_button_pressed():
	if Global.current != null:
		var credits = []
		var debits = []
		if Global.data.has(Global.current["id"]):
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
	if Global.data.has(Global.current["id"]):
		GlobalEngine.edit_budget($Title.text, $InfoBox/IncValue.text, $InfoBox/ExpValue.text, $InfoBox/SavValue.text)
	queue_free()

func _on_accept_dialog_confirmed():
	$AcceptDialog.hide()
	
func _on_entry_box_item_clicked(index, at_position, mouse_button_index):
	var instance = edit_entry_box.instantiate()
	add_child(instance)
	Events.emit_signal("edit_entry", $Ids.get_item_text(index))

func pop_text(type, value):

	match type:
		"credit":
			var instance = pop_up_text.instantiate()
			add_child(instance)
			instance.global_position = $InfoBox/IncValue.global_position
			instance.txt = str(value)
			Events.emit_signal("credit_added")
		"debit":
			var instance = pop_up_text.instantiate()
			add_child(instance)
			instance.global_position = $InfoBox/IncValue.global_position
			instance.txt = str(value)
			Events.emit_signal("debit_added")

func _on_title_mouse_entered():
	$PopupPanel.popup_centered()
	$PopupPanel/VBoxContainer/HBoxContainer/Confirm.pressed.connect(_change_title_confirmed)
	$PopupPanel/VBoxContainer/HBoxContainer/Cancel.pressed.connect(_change_title_cancelled)

func _change_title_confirmed():
	GlobalEngine.edit_budget($PopupPanel/VBoxContainer/LineEdit.text,$InfoBox/IncValue.text, $InfoBox/ExpValue.text, $InfoBox/SavValue.text)
	$Title.text = Global.current["title"]
	$PopupPanel.hide()
	$PopupPanel/VBoxContainer/LineEdit.clear()

func _change_title_cancelled():

	$PopupPanel.hide()
	$PopupPanel/VBoxContainer/LineEdit.clear()

func _on_Control_mouse_entered():
	initial_mouse_pos = get_local_mouse_position()
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var current_pos = event.position
		var delta = initial_mouse_pos - current_pos
		var scroll_container = $EntryBox
		scroll_container.scroll_vertical += delta.y

