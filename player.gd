extends CharacterBody2D

const SPEED = 200.0
var score = 0

@onready var flashlight = $PointLight2D
@onready var darkness = $".."/CanvasLayer/ColorRect

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
	
	# Zseblámpa a kurzor felé forog
	var mouse_pos = get_global_mouse_position()
	flashlight.rotation = (mouse_pos - global_position).angle()

func collect_artifact():
	score += 1
	print("Score: ", score)
	
func _process(delta):
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var uv_pos = mouse_pos / viewport_size
	darkness.material.set_shader_parameter("light_pos", uv_pos)
