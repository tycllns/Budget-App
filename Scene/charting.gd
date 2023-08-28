extends Panel


func calculate_values():
	var income = []
	var expenses = []

	for entry in Global.data:
		income.append(float(entry["income"]))
		expenses.append(float(entry["expenses"]))
		
	var total_income = Mathdoer.calculate_income(income)
	var total_expenses = Mathdoer.calculate_expenses(expenses)
	var savings = total_income - total_expenses
	
	var exppercent = Mathdoer.calculate_percentage(total_expenses,total_income)
	var savpercent = Mathdoer.calculate_percentage(savings,total_income)
	
	$VBoxContainer/Totals/IncValue.text = str(total_income)
	$VBoxContainer/Totals/ExpValue.text = str(total_expenses)
	$VBoxContainer/Totals/SavValue.text = str(savings)
	
	$"Total Percentages/Expenses".value = exppercent
	$"Total Percentages/Savings".value = savpercent

# Called when the node enters the scene tree for the first time.
func _ready():
	calculate_values()


func _on_back_pressed():
	queue_free()
