class_name ChunkSpawner extends Node2D

const CELL_ID := 'uid://bvon32feqiyn3'
var chunk_dimensions := Vector2(800, 800)
var cell_dimensions := Vector2(200, 200)
var matrix: Vector2
var max_chunks := 3
var chunks: Array[Chunk] = []

#Chunk should be 2d scene that is set dimensions (ie 400x400 or whatever)
#spawn asteroids in grid in chunk
#place chunk on map ahead of camera
#reset chunk after goes off camera
func _ready() -> void:
	matrix = chunk_dimensions/cell_dimensions
	for i in max_chunks:
		var pos = Vector2((i+1) * chunk_dimensions.x, -.5 * chunk_dimensions.y)
		spawn_chunk(pos)
	
func spawn_chunk(pos: Vector2) -> void:
	var cell = preload(CELL_ID)
	var new_chunk = Chunk.new()
	#new_chunk.position = Vector2( (i+1) * chunk_dimensions.x, -.5 * chunk_dimensions.y)
	new_chunk.position = pos
	for x in matrix.x:
		for y in matrix.y:
			var cell_inst = cell.instantiate()
			cell_inst.position = Vector2(x * cell_dimensions.x, y * cell_dimensions.y)
			#Tracking cells so when we have multiple cell layouts
			#we can randomize the order without completely regenerating
			new_chunk.cells.append(cell_inst)
			new_chunk.add_child(cell_inst)
		chunks.append(new_chunk)
		add_child(new_chunk)
