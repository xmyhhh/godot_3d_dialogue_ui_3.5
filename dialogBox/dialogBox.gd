
extends Spatial

export(NodePath) var top_node
export(NodePath) var center_node 
export(NodePath) var buttom_node 

export var reposition = false
export var buttom_as_reposition_origin = true

export var top_text_max_char:int = 8
export var center_text_max_char:int = 35
export var buttom_text_max_char:int = 4

export var top_text_reach_max_hide:bool = true
export var center_text_reach_max_hide:bool = true
export var buttom_text_reach_max_hide:bool = true

export var center_text_reach_max_auto_scroll:bool = true

export var auto_scroll_speed:float = 2.0
export var auto_scroll_duration:float = 2.0

#align
var self_init_pos
var center_init_size
var top_init_pos
var buttom_init_pos
var init = false

var top_text_node
var center_text_node
var buttom_text_node
var first_frame = true
#text arrage
var dialog_content = {
	"top": "",
	"center": "",
	"buttom": ""
}

func _ready():
	top_node = get_node(top_node)
	center_node = get_node(center_node)
	buttom_node = get_node(buttom_node)

func _process(delta):
	if(first_frame):
		first_frame = false
		yield(get_tree(),"idle_frame")
		
	if(top_node && center_node && buttom_node):
		if(not init):
			init = true
			top_text_node = top_node.get_child(0)
			center_text_node = center_node.get_child(0)
			buttom_text_node = buttom_node.get_child(0)
			self_init_pos = self.transform.origin
			center_init_size = center_node.get_min_aabb()
			top_init_pos = top_node.transform.origin
			buttom_init_pos = buttom_node.transform.origin
			return

		var top_pos = top_init_pos
		var buttom_pos = buttom_init_pos
		
		if(reposition):
			var y_change =  (center_node.get_aabb().y - center_init_size.y)  / 2.0
			var x_change =  (center_node.get_aabb().x - center_init_size.x)  / 2.0
			
			top_pos.y += y_change
			buttom_pos.y -= y_change
			top_pos.x -= x_change
			buttom_pos.x += x_change
			
			self.transform.origin.y = self_init_pos.y + y_change
			
		billboard(top_node, top_pos)
		billboard(buttom_node, buttom_pos)
#		update_render_layer()
		
func set_top(content):
	dialog_content["top"] = content
	if(top_text_reach_max_hide and top_text_max_char < content.length()):
		pass
	else:
		top_text_node.text = content

func set_center(content):
	var m_timer
	if(center_text_node.get_child(0) == null):
		m_timer = Timer.new()
		center_text_node.add_child(m_timer)
		m_timer.one_shot = true
		m_timer.connect("timeout", self, "center_text_tick")
	else:
		m_timer = center_text_node.get_child(0)
		
	m_timer.stop()
	
	dialog_content["center"] = content
	if(center_text_reach_max_hide and center_text_max_char < content.length()):
		buttom_node.show()
		center_text_node.text = dialog_content["center"].substr(0, center_text_max_char)
		dialog_content["center"] = dialog_content["center"].substr(center_text_max_char, -1)
		m_timer.start(auto_scroll_duration)
	else:
		buttom_node.hide()
		center_text_node.text = content
	
func set_buttom(content):
	buttom_text_node.text = content
	pass


func center_text_tick():
	if(dialog_content["center"].length()> center_text_max_char):
		center_text_node.text = dialog_content["center"].substr(0, center_text_max_char)
		dialog_content["center"] = dialog_content["center"].substr(center_text_max_char, -1)
	else:
		center_text_node.text = dialog_content["center"].substr(0, -1)
		dialog_content["center"] = ""
		buttom_node.hide()
	if(dialog_content["center"].length()> 0):
		var m_timer = center_text_node.get_child(0)
		m_timer.start(auto_scroll_duration)
		
func billboard(target_node, target_origin_offset):
	var cur_cam = get_tree().get_root().get_viewport().get_camera()
	if(cur_cam != null):
		var VIEW_MATRIX = cur_cam.global_transform
		target_node.transform.origin = Vector3(0, 0, 0) ;
		var p = VIEW_MATRIX.xform_inv(target_node.global_transform.origin) + Vector3(target_origin_offset.x, target_origin_offset.y,  0.0)
		target_node.global_transform.origin =  VIEW_MATRIX.xform(p)


#func update_render_layer():
#	var cur_cam = get_tree().get_root().get_viewport().get_camera()
#	var projection = cur_cam.get_camera_projection()
#
#	var VIEW_MATRIX = cur_cam.global_transform
#	var view_space = VIEW_MATRIX.xform(global_transform.origin)
#	var clip_space_vec4 =  projection  * Vector4(view_space.x, view_space.y, view_space.z, 1)
#	clip_space_vec4 /= clip_space_vec4.w
#
#	if(clip_space_vec4.z > 0.99 or clip_space_vec4.z < 0.88):
#		hide()
#	else:
#		show()
#
#	var layer_index_base = int((1.0 - clip_space_vec4.z) * 100000)
#	var layer_index_base_p = layer_index_base * 1.001
#	var layer_index_base_pp = layer_index_base_p * 1.001
	
