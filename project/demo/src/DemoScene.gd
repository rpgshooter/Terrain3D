extends Node

var terrain: Terrain3D

func _ready():
	terrain = find_terrain(get_tree().root)
	if terrain:
		center_test()
	else:
		print("No Terrain3D found!")

func find_terrain(node: Node) -> Terrain3D:
	if node is Terrain3D:
		return node
	for child in node.get_children():
		var result = find_terrain(child)
		if result:
			return result
	return null

func center_test():
	print("=== CLEAN CENTERING TEST ===")
	
	var size = 256
	var height_img = Image.create(size, size, false, Image.FORMAT_RF)
	height_img.fill(Color(0.5, 0, 0))
	
	# Peak at pixel (128, 128)
	for x in range(120, 136):
		for y in range(120, 136):
			height_img.set_pixel(x, y, Color(1.0, 0, 0))
	
	var images: Array[Image] = [height_img, null, null]
	
	terrain.vertex_spacing = 2.0
	var logical_pos = Vector3(-128, 0, -128)
	
	print("vertex_spacing: ", terrain.vertex_spacing)
	print("Logical position: ", logical_pos)
	print("")
	
	terrain.data.import_images(images, logical_pos)
	terrain.data.update_maps()
	
	print("Regions: ", terrain.data.get_region_locations())
	print("")
	print("Heights:")
	print("  (-256, -256): ", terrain.data.get_height(Vector3(-256, 0, -256)))
	print("  (-128, -128): ", terrain.data.get_height(Vector3(-128, 0, -128)))
	print("  (0, 0): ", terrain.data.get_height(Vector3(0, 0, 0)))
	print("  (128, 128): ", terrain.data.get_height(Vector3(128, 0, 128)))
	print("  (256, 256): ", terrain.data.get_height(Vector3(256, 0, 256)))
