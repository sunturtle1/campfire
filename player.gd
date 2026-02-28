extends CharacterBody2D

const acc = 300
const rot_speed = 2.5
const friction = 0.98
const brk_friction = 0.90
var score = 0
var lives = 2
var invincible = false

@onready var hearts = [
	get_tree().root.get_node("Main/CanvasLayer2/HeartContainer/Heart"),
	get_tree().root.get_node("Main/CanvasLayer2/HeartContainer/Heart2")
]
@onready var score_label = get_tree().root.get_node("Main/CanvasLayer2/Label")
@onready var flashlight = $PointLight2D
@onready var darkness = get_tree().root.get_node("Main/CanvasLayer2/ColorRect")
@onready var anim = $Sprite2D

func _ready() -> void:
	update_hearts()

func take_damage():
	if invincible:
		return
	invincible = true
	lives -= 1
	print("Lives: ", lives)
	update_hearts()
	
	if lives <= 0:
		var canvas = CanvasLayer.new()
		canvas.layer = 100
		var gameover = preload("res://scenes/game_over.tscn").instantiate()
		gameover.setup(score)
		canvas.add_child(gameover)
		get_tree().root.add_child(canvas)
	else:
		modulate.a = 0.5
		await get_tree().create_timer(2.0).timeout
		modulate.a = 1.0
		invincible = false

func update_hearts():
	for i in range(2):
		hearts[i].modulate.a = 1.0 if i < lives else 0.3
	score_label.text = "Collected treasure: " + str(score)

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		rotation += rot_speed * delta
	if Input.is_action_pressed("left"):
		rotation -= rot_speed * delta
	if Input.is_action_pressed("down"):
		velocity *= brk_friction
	else:
		velocity *= friction
	if Input.is_action_pressed("up"):
		velocity += Vector2.UP.rotated(rotation) * acc * delta

	if velocity.length() > 20:
		anim.play("default")
	else:
		anim.play("standstill")

	move_and_slide()

	var mouse_pos = get_global_mouse_position()
	flashlight.rotation = (mouse_pos - global_position).angle()

func collect_artifact():
	score += 1
	print("Score: ", score)
	update_hearts()

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var camera = $Camera2D
	var cam_zoom = camera.zoom

	var mouse_screen = get_viewport().get_mouse_position()
	var mouse_uv = mouse_screen / viewport_size
	darkness.material.set_shader_parameter("light_pos", mouse_uv)

	var player_screen = (global_position - camera.global_position) * cam_zoom + viewport_size / 2
	var player_uv = player_screen / viewport_size
	darkness.material.set_shader_parameter("player_pos", player_uv)
	darkness.material.set_shader_parameter("player_rotation", rotation)
