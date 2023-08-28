extends Node

var data = []
var save_path = "user://save.tres"
var current 
var new_budget

var expense_types = [
	"Rent",
	"Mortgage",
	"Utilities",
	"Groceries",
	"Transportation",
	"Insurance",
	"Taxes",
	"Healthcare",
	"Education",
	"Entertainment",
	"Dining out",
	"Clothing",
	"Debt repayment",
	"Charity",
	"Savings",
	"Investments",
	"Travel",
	"Subscriptions",
	"Home maintenance",
	"Pet expenses"
]

var income_types = [
	"Salary",
	"Wages",
	"Business income",
	"Investment income",
	"Rental income",
	"Freelance income",
	"Gifts",
	"Grants",
	"Refunds",
	"Bonuses",
	"Interest",
	"Dividends",
	"Royalties",
	"Alimony",
	"Child support",
	"Social Security benefits",
	"Retirement income",
	"Unemployment benefits",
	"Tax refunds",
	"Lottery or gambling winnings"
]

func _ready():
	load_data()

func load_data():
	if ResourceLoader.load(save_path) != null:
		print("loading Save File")
		var loaded_data = ResourceLoader.load(save_path).data
		data = loaded_data
	else:
		print("Creating Save File")
		save()

func save():
	var budgets = user_data.new()
	if current != null:
		for entry in data:
			if entry["id"] == current["id"]:
				print(true)
				data.remove_at(data.find(entry))
				data.append(current)
				#print("saving data")
				break
	budgets.data = data
	print("saving data")
	ResourceSaver.save(budgets, save_path)

#func save_budget(title, budget):
	#data["budgets"][title] = budget
	#print(data)
	#save()

#func add_entry(title,entry):
	#data["budgets"][title] = entry
	#save()
