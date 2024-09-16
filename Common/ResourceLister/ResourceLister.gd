class_name resource_lister

func getResourcesByPath(path: String):
	var dir = DirAccess.open(path)
	var resourceArray = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var resource = load(file_name)
			print(resource.resource_name)
			file_name = dir.get_next()
	
	return resourceArray
