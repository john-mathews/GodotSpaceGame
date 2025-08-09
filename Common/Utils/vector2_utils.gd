class_name Vector2Utils extends Node


static func max_v2(vects: Array[Vector2]) -> Vector2:
	var max_vect:= Vector2.ZERO
	for v in vects:
		if v.length() > max_vect.length():
			max_vect = v
	return max_vect

static func min_v2(vects: Array[Vector2]) -> Vector2:
	var min_vect: Vector2
	for v in vects:
		if min_vect == null:
			min_vect = v
		elif v.length() < min_vect.length():
			min_vect = v
	if min_vect == null:
		print_debug('Vectors required')
	return min_vect
