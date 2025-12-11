extends Node

var terrain: Terrain3D

func _ready():
	terrain = find_terrain(get_tree().root)
	if terrain:
		test_large_images()
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

func test_large_images():
	print("=== LARGE IMAGE TESTS ===\n")
	
	test_512_centered()
	test_1024_centered()
	test_1024_offset()

func test_512_centered():
	print("Test: 512x512 image centered on origin")
	terrain.vertex_spacing = 1.0
	
	var img = Image.create(512, 512, false, Image.FORMAT_RF)
	img.fill(Color(0.5, 0, 0))
	# Peak at center (256, 256)
	for x in range(254, 258):
		for z in range(254, 258):
			img.set_pixel(x, z, Color(1.0, 0, 0))
	
	var images: Array[Image] = [img, null, null]
	terrain.data.import_images(images, Vector3(-256, 0, -256))
	terrain.data.update_maps()
	
	print("  Regions: ", terrain.data.get_region_locations())
	print("  Region count: ", terrain.data.get_region_locations().size())
	print("  Expected: 4 regions")
	print("  Peak at (0,0): ", terrain.data.get_height(Vector3(0, 0, 0)))
	print("  Expected: ~1.0")
	print("")

func test_1024_centered():
	print("Test: 1024x1024 image centered on origin")
	terrain.vertex_spacing = 1.0
	
	var img = Image.create(1024, 1024, false, Image.FORMAT_RF)
	img.fill(Color(0.5, 0, 0))
	# Peak at center (512, 512)
	for x in range(510, 514):
		for z in range(510, 514):
			img.set_pixel(x, z, Color(1.0, 0, 0))
	
	var images: Array[Image] = [img, null, null]
	terrain.data.import_images(images, Vector3(-512, 0, -512))
	terrain.data.update_maps()
	
	print("  Regions: ", terrain.data.get_region_locations())
	print("  Region count: ", terrain.data.get_region_locations().size())
	print("  Expected: 16 regions (4x4) with region_size=256")
	print("  Peak at (0,0): ", terrain.data.get_height(Vector3(0, 0, 0)))
	print("  Expected: ~1.0")
	print("")

func test_1024_offset():
	print("Test: 1024x1024 image at offset position")
	terrain.vertex_spacing = 1.0
	
	var img = Image.create(1024, 1024, false, Image.FORMAT_RF)
	img.fill(Color(0.5, 0, 0))
	# Peak at (100, 100)
	for x in range(98, 102):
		for z in range(98, 102):
			img.set_pixel(x, z, Color(1.0, 0, 0))
	
	var images: Array[Image] = [img, null, null]
	terrain.data.import_images(images, Vector3(500, 0, 500))
	terrain.data.update_maps()
	
	print("  Regions: ", terrain.data.get_region_locations())
	print("  Region count: ", terrain.data.get_region_locations().size())
	print("  Peak at (600, 600): ", terrain.data.get_height(Vector3(600, 0, 600)))
	print("  Expected: ~1.0 (500 + 100 = 600)")
	print("")
