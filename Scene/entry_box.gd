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

func _ready():
	$"Middle Panel/Type".add_item("credit")
	#hi
	$"Middle Panel/Type".add_item("debit")
	$"Exclamation Title".play("default")
	$"Exclamation Value".play("default")

func _on_add_entry_pressed():
	if $"Top Panel/Title".text == "":
		$"Exclamation Title".show()
		return
	elif $"Middle Panel/Value".text == "":
		$"Exclamation Value".show()
		return

	GlobalEngine.add_entry($"Top Panel/Title".text, $"Middle Panel/Value".text, $"Middle Panel/Type".text)
	Events.emit_signal("get_entries")
	Events.emit_signal("calculate")
	queue_free()


func _on_cancel_pressed():
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
