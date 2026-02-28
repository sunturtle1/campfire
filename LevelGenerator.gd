extends Node2D

const MAP_WIDTH = 100
const MAP_HEIGHT = 100
const TILE_SIZE = 16

const FLOOR_COORDS = Vector2i(0, 0)
const WALL_COORDS = Vector2i(0, 4)

@onready var tilemap = $TileMap

var map = []

func _ready():
	generate_map()
	smooth_map(3)  
	apply_map()
	spawn_artifacts()
	spawn_player()
	spawn_enemies()
	
func spawn_enemies():
	var enemy_scene = preload("res://scenes/Enemy.tscn")
	var floor_cells = tilemap.get_used_cells_by_id(0, 0, FLOOR_COORDS)
	var center = Vector2i(MAP_WIDTH / 2, MAP_HEIGHT / 2)
	
	var spawned = 0
	var attempts = 0
	
	while spawned < 3 and attempts < 100:
		attempts += 1
		var random_cell = floor_cells.pick_random()
		var dist = random_cell.distance_to(center)
		
		if dist < 30:
			continue
		
		var enemy = enemy_scene.instantiate()
		enemy.global_position = tilemap.map_to_local(random_cell)
		add_child(enemy)
		spawned += 1

func generate_map():
	map = []
	for x in range(MAP_WIDTH):
		map.append([])
		for y in range(MAP_HEIGHT):
			
			if x == 0 or x == MAP_WIDTH-1 or y == 0 or y == MAP_HEIGHT-1:
				map[x].append(0)
			else:
				map[x].append(1 if randf() > 0.35 else 0)

func smooth_map(iterations):
	for i in range(iterations):
		var new_map = []
		for x in range(MAP_WIDTH):
			new_map.append([])
			for y in range(MAP_HEIGHT):
				var walls = count_nearby_walls(x, y)
				if walls > 4:
					new_map[x].append(0)  # fal
				else:
					new_map[x].append(1)  # floor
		map = new_map

func count_nearby_walls(x, y):
	var count = 0
	for nx in range(x-1, x+2):
		for ny in range(y-1, y+2):
			if nx < 0 or nx >= MAP_WIDTH or ny < 0 or ny >= MAP_HEIGHT:
				count += 1
			elif map[nx][ny] == 0:
				count += 1
	return count

func apply_map():
	var wall_count = 0
	var floor_count = 0
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			if map[x][y] == 1:
				tilemap.set_cell(0, Vector2i(x, y), 0, FLOOR_COORDS)
				floor_count += 1
			else:
				tilemap.set_cell(0, Vector2i(x, y), 0, WALL_COORDS)
				wall_count += 1
	print("Falak: ", wall_count, " Floor: ", floor_count)

func spawn_artifacts():
	var artifact_scene = preload("res://scenes/artifact.tscn")
	var floor_cells = tilemap.get_used_cells_by_id(0, 0, FLOOR_COORDS)
	var numberofartifacts = randi() % 15 + 10
	print(numberofartifacts)
	for i in range(numberofartifacts):
		var random_cell = floor_cells.pick_random()
		var artifact = artifact_scene.instantiate()
		artifact.global_position = tilemap.map_to_local(random_cell)
		add_child(artifact)

func spawn_player():
	var center = Vector2i(MAP_WIDTH / 2, MAP_HEIGHT / 2)
	var player = get_node("Player")
	player.global_position = tilemap.map_to_local(center)
	
	var camera = player.get_node("Camera2D")
	camera.reset_smoothing()
	print("limits set: ", camera.limit_left, " ", camera.limit_right)
