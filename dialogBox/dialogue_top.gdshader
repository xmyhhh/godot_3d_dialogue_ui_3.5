shader_type spatial;
render_mode unshaded, diffuse_toon;
uniform vec2 size = vec2(64.0, 64.0);
uniform vec3 origin_offset = vec3(0.0);
uniform vec4 color_d  : hint_color = vec4(1.0);

vec4 draw_circle(vec4 in_color, vec2 in_pos, vec4 draw_color, vec2 pos, float r){
	vec4 out_color = in_color;
	
	if(length(in_pos - pos) < r)
		out_color = draw_color;
	
	return out_color;
}

vec4 draw_rounded_rectangle(vec4 in_color,vec2 in_pos, vec4 draw_color, vec2 pos, float width, float height, float r){
	vec4 out_color = in_color;
	vec2 in_pos_to_center = in_pos - pos;
	


	if( abs(in_pos_to_center.x) > width/2.0 || abs(in_pos_to_center.y) > height/2.0)
		return out_color;

	if(abs(in_pos_to_center.y) < (height / 2. - r)  || abs(in_pos_to_center.x) < (width / 2. - r))
		out_color = draw_color;
	
	if(length(abs(in_pos_to_center) - vec2(width/2.0 - r, height/2.0 - r)) < r)
		out_color = draw_color;

	return out_color;
}



void vertex(){
	MODELVIEW_MATRIX =  INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]) ;

	vec4 offset_dir = CAMERA_MATRIX  * WORLD_MATRIX * vec4(origin_offset, 1.0) - CAMERA_MATRIX  * WORLD_MATRIX * vec4(0.,0.,0., 1.0);
	float offset_dir_z_dis = dot(vec3(0, 0, -1), offset_dir.xyz);
	VERTEX = VERTEX - offset_dir.xyz + vec3(origin_offset.x, origin_offset.y, 0.);
}

void fragment() {

	vec2 uv_center = (UV - vec2(0.5, 0.5));
	vec2 pixel_pos = uv_center * size;
	pixel_pos.y = -pixel_pos.y;
	vec4 color = vec4(0.);

	vec2 rounded_rectangle_size = vec2(size.x - 10., 40.);
	vec2 rounded_rectangle_pos  =  vec2(0., 0.);
	vec4 rounded_rectangle_color = color_d;
	float rounded_rectangle_r = 20.;

	color = draw_rounded_rectangle(color, pixel_pos, rounded_rectangle_color,rounded_rectangle_pos, rounded_rectangle_size.x, rounded_rectangle_size.y, rounded_rectangle_r);

	ALBEDO = color.rgb;
	ALPHA = color.a;
	//ALBEDO = vec3(1.0);
}
