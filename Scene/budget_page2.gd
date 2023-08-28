extends Panel

var entry_box = preload("res://Scene/entry_box.tscn")

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
		print("creating budget")
		Global.new_budget = false
	else:
		GlobalEngine.edit_budget($Title.text, $InfoBox/IncValue.text, $InfoBox/ExpValue.text, $InfoBox/SavValue.text)
	var instance = entry_box.instantiate()
	add_child(instance)
