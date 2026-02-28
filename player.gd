extends CharacterBody2D

const acc = 300
const rot_speed = 2.5
const friction = 0.98
const brk_friction = 0.90
var score = 0

@onready var flashlight = $PointLight2D
@onready var darkness = get_tree().root.get_node("Main/CanvasLayer/ColorRect")
@onready var anim = $Sprite2D
func _ready() -> void:
	print(darkness)
func _physics_process(delta):
	
	
	if Input.is_action_pressed("right"):
		rotation += rot_speed * delta
		anim.play("default")
	if Input.is_action_pressed("left"):
		rotation -= rot_speed * delta
		anim.play("default")
	if Input.is_action_pressed("down"):
		velocity *= brk_friction
	else: 
		velocity *= friction
	if Input.is_action_pressed("up"):
		velocity += Vector2.UP.rotated(rotation) * acc * delta
		anim.play("default")
		
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
	
func _process(delta):
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var uv_pos =  Vector2(mouse_pos.x / viewport_size.x, mouse_pos.y / viewport_size.y)
	
	
	darkness.material.set_shader_parameter("light_pos", uv_pos)
