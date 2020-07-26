extends Node2D
export (PackedScene) var Segment

const TILE_SIZE = 60 #Must be a common factor 720 & 1080
const START_POS = Vector2(5 * TILE_SIZE, 10 * TILE_SIZE)
const LEVEL_SIZE = [12, 18] #[#Horizontal Tiles, #Vertical Tiles]
const SPEED = 0.076 #Speed in seconds, for timer to move the player
const MAX_WIDTH = 720
const MAX_HEIGHT = 1050

var block = preload("block.gd").Block
var level = []
var snake = []
var dir = null
var pellet_placed = null

enum {N, E, S, W}

func _ready():
	randomize()
	new_game()
	
	var timer = Timer.new()
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(SPEED)
	timer.set_one_shot(false)
	timer.start()
	
	pass

func _process(_delta):
	dir = $Head.get_dir()
	
	if Input.is_action_pressed("ui_cancel"):
		queue_free()
		get_tree().quit()
	
	if Input.is_action_just_pressed("ui_accept"):
		new_game()
		
	if Input.is_action_just_pressed("ui_size"):
		print(snake.size())
	
	if $Head.position.x >= MAX_WIDTH or $Head.position.x < 0 or $Head.position.y > MAX_HEIGHT or $Head.position.y < 0:
		game_over()

	pass

func build_level_array (width, height):
	var level_array = []

	for x in range(width):
		level_array.append([])
		level_array[x].resize(height)

		for y in range(height):
			level_array[x][y] = block.new(Vector2(x * TILE_SIZE, y * TILE_SIZE))

	return level_array

func new_game():
	$GameOver.visible = false
	$Head.visible = true
	$Pellet.visible = true
	level = build_level_array(LEVEL_SIZE[0], LEVEL_SIZE[1])
	$Head.position = START_POS
	$Head.set_dir(N)
	pellet_placed = false
	
	for i in snake.size():
		if snake[i].get_class() == "StaticBody2D":
			snake[i].queue_free()
	
	snake = []
	snake.append($Head)
	
	pass

func game_over():
	$GameOver.visible = true
	$Head.visible = false
	$Pellet.visible = false
	
	for i in snake.size():
		snake[i].visible = false
	
	pass

func _on_Timer_timeout():
	var last_pos = null
	var last_tail = null

	if dir == N:
		last_pos = snake[0].position
		snake[0].position.y -= TILE_SIZE
		for i in snake.size():
			if snake.size() > 1 and i > 0:
				if i % 2 == 0:
					last_pos = snake[i].position
					snake[i].position = last_tail
				else:
					last_tail = snake[i].position
					snake[i].position = last_pos

	elif dir == E:
		last_pos = snake[0].position
		snake[0].position.x += TILE_SIZE
		for i in snake.size():
			if snake.size() > 1 and i > 0:
				if i % 2 == 0:
					last_pos = snake[i].position
					snake[i].position = last_tail
				else:
					last_tail = snake[i].position
					snake[i].position = last_pos

	elif dir == S:
		last_pos = snake[0].position
		snake[0].position.y += TILE_SIZE
		for i in snake.size():
			if snake.size() > 1 and i > 0:
				if i % 2 == 0:
					last_pos = snake[i].position
					snake[i].position = last_tail
				else:
					last_tail = snake[i].position
					snake[i].position = last_pos

	else:
		last_pos = snake[0].position
		snake[0].position.x -= TILE_SIZE
		for i in snake.size():
			if snake.size() > 1 and i > 0:
				if i % 2 == 0:
					last_pos = snake[i].position
					snake[i].position = last_tail
				else:
					last_tail = snake[i].position
					snake[i].position = last_pos

	if pellet_placed == false:
		var randx = randi() % LEVEL_SIZE[0] - 1
		var randy = randi() % LEVEL_SIZE[1] - 1

		for i in snake.size():
			if level[randx][randy].get_coord() != snake[i].position:
				place_pellet(level[randx][randy].get_coord())

	pass

func place_pellet(vec):
	$Pellet.position = vec
	pellet_placed = true
	$Pellet.visible = true
	
	pass

func _on_Head_pellet_touch():
	pellet_placed = false
	$Pellet.visible = false
	
	var segment = Segment.instance()
	add_child(segment)
	
	#Place the segment "off-screen" to avoid the rare event of it briefly inter-
	#secting the player at its base pos of 0,0
	if dir == N:
		snake.append(segment)
		snake[snake.size()-1].position = Vector2(-60,-60)

	if dir == E:
		snake.append(segment)
		snake[snake.size()-1].position = Vector2(-60,-60)

	if dir == S:
		snake.append(segment)
		snake[snake.size()-1].position = Vector2(-60,-60)
		
	elif dir == W:
		snake.append(segment)
		snake[snake.size()-1].position = Vector2(-60,-60)
		
	pass 

func _on_Head_segment_touch():
	game_over()
	
	pass 


func _on_Pellet_pellet_blocked():
	pellet_placed = false
	pass # Replace with function body.
