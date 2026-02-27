extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	# Lebegő animáció
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", position.y - 8, 1.0)
	tween.tween_property(self, "position:y", position.y + 8, 1.0)

func _on_body_entered(body):
	if body.name == "Player":
		body.collect_artifact()
		queue_free()
