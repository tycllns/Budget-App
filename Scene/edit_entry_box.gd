extends Panel
var asciiLettersAndSymbols = [
	"!",
	"\"",
	"#",
	"$",
	"%",
	"&",
	"\'",
	"(",
	")",
	"*",
	"+",
	",",
	"-",
	".",
	"/",
	":",
	";",
	"<",
	"=",
	">",
	"?",
	"@",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"[",
	"\\",
	"]",
	"^",
	"_",
	"`",
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"{",
	"|",
	"}",
	"~"
]
var identification

func _ready():
	Events.edit_entry.connect(load_entry)
	$"Middle Panel/Type".add_item("credit")
	$"Middle Panel/Type".add_item("debit")
	
func find_option_index(option_button, target_item): 
	for i in range(option_button.get_item_count()):
		if option_button.get_item_text(i) == target_item:         
			return i
	return -1  # Item not found

func load_entry(id):
	identification = id
	var credits = Global.current["credits"]
	var debits = Global.current["debits"]

	for entry in credits:
		if entry["id"] == id:
			$"Top Panel/Title".text = entry["title"]
			$"Top Panel/Title".text = $"Top Panel/Title".text.replace(" - Credit", "").replace(" - Debit", "")
			$"Middle Panel/Value".text = entry["value"]
			var type_index = find_option_index($"Middle Panel/Type", entry["type"])
			print(type_index)
			if type_index >=0:
				$"Middle Panel/Type".select(type_index)
			break

	for entry in debits:
		if entry["id"] == id:
			$"Top Panel/Title".text = entry["title"]
			$"Top Panel/Title".text = $"Top Panel/Title".text.replace(" - Credit", "").replace(" - Debit", "")
			$"Middle Panel/Value".text = entry["value"]
			var type_index = find_option_index($"Middle Panel/Type", entry["type"])
			print(type_index)
			if type_index >=0:
				$"Middle Panel/Type".select(type_index)
			break

func _on_apply_pressed():
	if $"Top Panel/Title".text == "":
		$"Exclamation Title".show()
		return
	elif $"Middle Panel/Value".text == "":
		$"Exclamation Value".show()
		return
	var dict = {
		"title":$"Top Panel/Title".text,
		"value":$"Middle Panel/Value".text,
		"type":$"Middle Panel/Type".text,
		"id":identification
	}
	GlobalEngine.edit_entry(identification,dict["title"],dict)
	Events.emit_signal("get_entries")
	Events.emit_signal("calculate")
	queue_free()


func _on_value_text_changed(new_text):
	var filtered_text = ""
	
	for i in range(new_text.length()):
		var char = new_text[i] 
		var numbers = ["1","2","3","4","5","6","7","8","9","0"]
		if numbers.has(char):   
			filtered_text += char
			$"Exclamation Value".visible = false
		if asciiLettersAndSymbols.has(char):
			$"Exclamation Value".visible = true
	$"Middle Panel/Value".text = filtered_text
	$"Middle Panel/Value".caret_column = filtered_text.length()


func _on_delete_pressed():
	$ConfirmationDialog.dialog_text = "Are you sure you want to delete " + $"Top Panel/Title".text + " ?"
	$ConfirmationDialog.confirmed.connect(_on_delete_confirmed)
	$ConfirmationDialog.popup_centered()

func _on_delete_confirmed():
	GlobalEngine.delete_entry(identification)
	Events.emit_signal("get_entries")
	queue_free()


func _on_cancel_pressed():
	queue_free()
