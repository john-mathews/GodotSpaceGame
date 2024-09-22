class_name ResourceLister

static func getResourcesByPath(path: String):
	var dir = DirAccess.open(path)
	var resourceArray = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				resourceArray.push_back(path+file_name)
			file_name = dir.get_next()
	
	return resourceArray
