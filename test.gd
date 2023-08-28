extends Node2D

func _ready():
	$LineEdit.text = "TYler"
	calculate_values()

func _on_add_budget_pressed():
	var credits = []
	var debits = []
	GlobalEngine.create_budget($LineEdit.text, 5000, 200, 50, credits, debits)


func _on_add_entry_pressed():
	GlobalEngine.add_entry($LineEdit.text,"name",0,"rent","credit")

func calculate_values():
	var credits = []
	var debits = []
	var budget = Global.data["budgets"][$LineEdit.text]

	if budget:
		if budget.has("credits"):      
			for credit in budget["credits"]:        
				if credit.has("value"):       
					credits.append(credit["value"])

		if budget.has("debits"):
			for debit in budget["debits"]:      
				if debit.has("value"):           
					debits.append(debit["value"])

	var total_income = Mathdoer.calculate_income(credits)
	var total_expenses = Mathdoer.calculate_expenses(debits)
	var savings = total_income - total_expenses

	$Income.text = str(total_income)
	$Expenses.text = str(total_expenses)
	$Savings.text = str(savings)
