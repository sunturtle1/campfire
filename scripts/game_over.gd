extends Control

var pending_score = 0

func setup(score: int):
	pending_score = score

func _ready() -> void:
	$VBoxContainer/EndScoreLabel.text = "Collected treasure: " + str(pending_score)

func _on_button_pressed() -> void:
	get_parent().queue_free()
	get_tree().reload_current_scene()
	
