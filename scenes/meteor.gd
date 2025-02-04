extends Area2D

var speed: int 
var rotation_speed: int
var direction_x: float

signal collision
var can_collide := true

func get_png_files_in_path(path: String) -> Array:
	var png_files = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break  # No more files to read
			if !dir.current_is_dir() and file_name.ends_with(".png"):
				png_files.append(path + file_name)
	else:
		print("Failed to open directory: " + path)
	
	return png_files

func _ready():
	var rng := RandomNumberGenerator.new()
	
	# texture 
	# NOTE: BUG on using get_png_files_in_path after exporting to HTML
	#var png_files = get_png_files_in_path("res://graphics/Meteors/")
	#var random_index = rng.randi_range(0, png_files.size() - 1)  # Random index in the array
	#var random_item = png_files[random_index]
	#$Sprite2D.texture = ResourceLoader.load(random_item)
	var random_index = rng.randi_range(1, 4)
	var random_item = "meteorBrown_big" + str(random_index) + ".png"
	var path = "res://graphics/Meteors/" + random_item
	$Sprite2D.texture = ResourceLoader.load(path)
	
	# start position
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0, width)
	var random_y = rng.randf_range(-150, -50)
	position = Vector2(random_x, random_y)
	
	# speed / rotation / direction
	speed = rng.randi_range(200, 500)
	direction_x = rng.randf_range(-1, 1)
	rotation_speed = rng.randi_range(40, 100)
	
	
func _process(delta: float) -> void:
	position += Vector2(direction_x, 1.0) * speed * delta
	rotation_degrees += rotation_speed * delta
	

func _on_body_entered(_body: Node2D) -> void:
	if can_collide:
		collision.emit()


# laser is the Area2D
func _on_area_entered(area: Area2D) -> void:
	area.queue_free() # remove the laser
	$ExplosionSound.play()
	$Sprite2D.hide()
	can_collide = false
	await get_tree().create_timer(0.5).timeout
	queue_free() # remove the meteor
