tool
extends Spatial

onready var origin_offset = Vector3(0, 0, 0)
#export(NodePath) var occlusion_node

var min_size = null
var init = false

func get_min_aabb():
	if(init):
		return min_size
	else:
		return null

func _process(delta):
	origin_offset = transform.origin
	var label_node = get_child(0)
	var label_pixel_size = label_node.get_aabb().size / self.pixel_size
	label_pixel_size.x += 60
	label_pixel_size.y += 60
	if(init):
		label_pixel_size.x = max(label_pixel_size.x, min_size.x)
		label_pixel_size.y = max(label_pixel_size.y, min_size.y)
	self.texture.width = label_pixel_size.x
	self.texture.height = label_pixel_size.y
	self.material_override.set_shader_param("size", label_pixel_size)
	self.material_override.set_shader_param("origin_offset", origin_offset)

	if(not init):
		init = true
		min_size = label_pixel_size
		
	var cur_cam = get_tree().get_root().get_viewport().get_camera()
	if(cur_cam != null):
		var MODEL_MATRIX = global_transform
		var VIEW_MATRIX = cur_cam.global_transform
		var offset_dir = MODEL_MATRIX.xform(origin_offset) - MODEL_MATRIX.xform(Vector3(0, 0, 0))
		label_node.global_transform.origin = global_transform.origin - offset_dir ;
		var tmp =  (VIEW_MATRIX.xform(label_node.global_transform.origin) + Vector3(origin_offset.x, origin_offset.y,  0.0))
		label_node.global_transform.origin =  VIEW_MATRIX.xform_inv(tmp) 

#	if(occlusion_node != null):
#		occlusion_node.texture.width = label_pixel_size.x
#		occlusion_node.texture.height = label_pixel_size.y
#		occlusion_node.material_override.set_shader_param("size", label_pixel_size)
#		occlusion_node.material_override.set_shader_param("origin_offset", origin_offset)
