extends Label

@export var txt : String
var symbol

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.credit_added.connect(credit_added)
	Events.debit_added.connect(debit_added)

func credit_added():
	modulate = Color.FOREST_GREEN
	symbol = "+"
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(200,-200),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(self.queue_free)
	tween.play()

func debit_added():
	modulate = Color.ORANGE_RED
	symbol = "-"
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(200,200),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(self.queue_free)
	tween.play()

func _process(delta):
	text = symbol + txt
