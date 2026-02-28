extends CharacterBody2D
const SPEED = 50.0
const DETECTION_RANGE = 600

var player = null
var wandering_dir = Vector2.RIGHT

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$Area2D.body_entered.connect(_on_body_entered)
	wandering_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta):
	if player == null:
		return
	
	var dist = global_position.distance_to(player.global_position)
	
	if dist < DETECTION_RANGE:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * SPEED
	else:
		wandering_dir = wandering_dir.rotated(randf_range(-0.1, 0.1))
		velocity = wandering_dir * (SPEED * 0.5)
	
	move_and_slide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()
