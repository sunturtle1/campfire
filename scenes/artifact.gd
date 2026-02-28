extends Area2D
@onready var sprite = $AnimatedSprite2D
var light_pos : Vector2
var radius : float = 0.2
var softness : float = 0.15
func _ready():
	body_entered.connect(_on_body_entered)
	
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", position.y - 6, 1.0)
	tween.tween_property(self, "position:y", position.y + 6, 1.0)

func _on_body_entered(body):
	if body.name == "Player":
		body.collect_artifact()
		
		sprite.play("default")
		await get_tree().create_timer(0.5).timeout 
		
		queue_free()
		
func _process(delta):
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_uv = mouse_pos / viewport_size
	
	var camera = get_viewport().get_camera_2d()
	var my_screen_pos = global_position - camera.global_position + viewport_size / 2
	var my_uv = my_screen_pos / viewport_size
	
	var dist = mouse_uv.distance_to(my_uv)
	sprite.visible = dist < radius
