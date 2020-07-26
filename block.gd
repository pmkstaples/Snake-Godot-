extends Resource

class Block:

	var coord = null

	func _init(vector):
		self.coord = vector
		
		pass

	func get_coord():
		
		return self.coord
