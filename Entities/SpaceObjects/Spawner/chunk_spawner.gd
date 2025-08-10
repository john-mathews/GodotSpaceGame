class_name ChunkSpawner extends Node2D

const CELL_ID := 'uid://bvon32feqiyn3'
var chunk_dimensions := Vector2(600, 800)
var cell_dimensions := Vector2(200, 200)
var matrix: Vector2
var max_chunks := 5
var chunks: Array[Chunk] = []
var chunk_count:= 0
var asteroids: Array[Node]:
	get():
		return get_tree().get_nodes_in_group('Asteroids')

#Chunk should be 2d scene that is set dimensions (ie 400x400 or whatever)
#spawn asteroids in grid in chunk
#place chunk on map ahead of camera
#reset chunk after goes off camera
func _ready() -> void:
	matrix = chunk_dimensions/cell_dimensions
	for i in max_chunks:
		var pos = Vector2((i+1) * chunk_dimensions.x, -.5 * chunk_dimensions.y)
		spawn_chunk(i)
		
func spawn_chunk(index: int) -> void:
	if index < max_chunks && chunks.size() > index && chunks[index] != null:
		print('jk')
		return
	var cell = preload(CELL_ID)
	var new_chunk = Chunk.new()
	#new_chunk.position = Vector2( (i+1) * chunk_dimensions.x, -.5 * chunk_dimensions.y)
	new_chunk.position = Vector2((index+1) * chunk_dimensions.x, -.5 * chunk_dimensions.y)
	for x in matrix.x:
		for y in matrix.y:
			var cell_inst = cell.instantiate()
			cell_inst.position = Vector2(x * cell_dimensions.x, y * cell_dimensions.y)
			#Tracking cells so when we have multiple cell layouts
			#we can randomize the order without completely regenerating
			new_chunk.cells.append(cell_inst)
			new_chunk.add_child(cell_inst)
	if chunks.size() == max_chunks:
		var chunk_index = index % max_chunks
		chunks[chunk_index].queue_free()
		chunks[chunk_index] = new_chunk
	else:
		chunks.append(new_chunk)
	add_child(new_chunk)
	
