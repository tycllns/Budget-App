extends Node

func calculate_expenses(expenses_list: Array) -> float:
	var total_expenses = 0.0
	for expense in expenses_list:
		total_expenses += expense
	return total_expenses

func calculate_income(income_list: Array) -> float:
	var total_income = 0.0
	for income in income_list:
		total_income += income
	return total_income

func calculate_savings(income: float, expenses: float) -> float:
	return income - expenses

func calculate_percentage(expenses: float, income: float) -> float:
	if income != 0.0:
		var percentage = (expenses / income) * 100
		return int(percentage)
	else:
		print("Income is zero, cannot calculate expense percentage.")
		return 0.0
