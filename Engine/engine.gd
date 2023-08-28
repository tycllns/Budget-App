extends Node


#CHECK METHODS:

func check_for_existing(id):
	for entry in Global.data:
		if entry["id"] == id:
			return true
		else:
			return false


#GET METHODS

func get_entry(id):
	for entry in Global.current["credits"] and Global.current["debits"]:
		if entry["id"] == id:
			return entry

func get_entry_name(id):
	for entry in Global.current["credits"]:
		if entry["id"] == id:
			return entry["title"]

func get_budget(id):
	for entry in Global.data:
		if entry["id"] == id:
			return entry

func get_budgets():
	return Global.data


#SET METHODS:

func set_current(budget):
	Global.current = budget


#CREATE METHODS

func generateUniqueEntrySerialCode() -> String:
	const SERIAL_CODE_LENGTH = 6
	var uniqueCode = ""
	var existingSerialCodes = []

	# Extract all existing serial codes from the budgets dictionary
	for entry in Global.current["credits"]:
		existingSerialCodes.append(entry["id"])
	for entry in Global.current["debits"]:
		existingSerialCodes.append(entry["id"])
		# Generate a random six-digit serial code
	while uniqueCode == "" or uniqueCode in existingSerialCodes:
		uniqueCode = var_to_str(randi_range(0, int(pow(10, SERIAL_CODE_LENGTH))))
		# Pad zeros to ensure the code has six digits
		while uniqueCode.length() < SERIAL_CODE_LENGTH:
			uniqueCode = "0" + uniqueCode
	return uniqueCode

func generateUniqueBudgetSerialCode() -> String:
	const SERIAL_CODE_LENGTH = 6
	var uniqueCode = ""
	var existingSerialCodes = []
	var budgets = Global.data
	
	# Extract all existing serial codes from the budgets dictionary
	for budget in Global.data:
		existingSerialCodes.append(budget["id"])
		
		# Generate a random six-digit serial code
	while uniqueCode == "" or uniqueCode in existingSerialCodes:
		uniqueCode = var_to_str(randi_range(0, int(pow(10, SERIAL_CODE_LENGTH))))
		# Pad zeros to ensure the code has six digits
		while uniqueCode.length() < SERIAL_CODE_LENGTH:
			uniqueCode = "0" + uniqueCode
	return uniqueCode

func create_budget(title, income, expenses, savings, credits, debits):
	print("creating budget")
	var budget = {
		"income": income,
		"expenses": expenses,
		"savings": savings,
		"credits": credits,
		"debits": debits,
		"title":title,
		"id": generateUniqueBudgetSerialCode()
	}
	Global.data.append(budget)
	set_current(budget)
	Global.save()

func add_entry(entryname, value, type):
	
	var ent = {
		"title": entryname,
		"type": type,
		"value": value,
		"id": generateUniqueEntrySerialCode()
	}
	if Global.current != null:
		match type:
			"credit":
				Global.current["credits"].append(ent)
				Events.emit_signal("pop_up_text", "credit", ent["value"])
			"debit":
				Global.current["debits"].append(ent)
				Events.emit_signal("pop_up_text", "debit", ent["value"])
		Global.save()
	else:
		printerr("Budget does not exist")


#EDIT METHODS:

func edit_budget(title,income, expenses, savings):
	print("editing budget")
	Global.current["title"] = title
	Global.current["income"] = income
	Global.current["expenses"] = expenses
	Global.current["savings"] = savings
	move_entries()
	Global.save()

func edit_entry(id, enttitle, newEntry):
	print("editing entry")
	for entry in Global.current["credits"]:
		if entry["id"] == id:
			Global.current["credits"].erase(entry)
			Global.current["credits"].append(newEntry)
	for entry in Global.current["debits"]:
		if entry["id"] == id:
			Global.current["debits"].erase(entry)
			Global.current["debits"].append(newEntry)
	move_entries()

func move_entries():
	print("moving entries")
	for entry in Global.current["credits"]:
		if entry["type"] == "debit":
			Global.current["debits"].append(entry)
			Global.current["credits"].erase(entry)
	for entry in Global.current["debits"]:
		if entry["type"] == "credit":
			Global.current["credits"].append(entry)
			Global.current["debits"].erase(entry)


#DELETE METHODS:

func delete_budget(id):
	print("deleting budget")
	for entry in Global.data:
		if entry["id"] == id:
			Global.data.erase(entry)
			Global.current = null
			Global.save()
		else:
			printerr("Budget does not exist")

func delete_entry(id):
	print("deleting entry")
	for entry in Global.current["credits"]:
		if entry["id"] == id:
			Global.current["credits"].erase(entry)
	for entry in Global.current["debits"]:
		if entry["id"] == id:
			Global.current["debits"].erase(entry)


