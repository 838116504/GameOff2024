shader_type canvas_item;
render_mode blend_add;

uniform int blur_strength:hint_range(0, 100) = 2;
uniform vec4 color:source_color;
uniform float u_shrink = 0.0;

vec4 get_blur_color(sampler2D p_tex, vec2 p_uv, vec2 p_pixelSize, float p_strength)
{
	vec4 ret = vec4(0.0, 0.0, 0.0, 0.0);
	int sx = int(p_uv.x / p_pixelSize.x - p_strength);
	int ex = int(p_uv.x / p_pixelSize.x + p_strength);
	int sy = int(p_uv.y / p_pixelSize.y - p_strength);
	int ey = int(p_uv.y / p_pixelSize.y + p_strength);
	int texW = int(1.0 / p_pixelSize.x);
	int texH = int(1.0 / p_pixelSize.y);
	for (int x = sx; x <= ex; ++x)
	{
		if (x < 0 || x > texW)
			continue;
		
		for (int y = sy; y <= ey; ++y)
		{
			if (y < 0 || y > texH)
				continue;
			
			ret += texture(p_tex, vec2(float(x), float(y)) * p_pixelSize);
		}
	}
	
	ret /= float((ex - sx + 1) * (ey - sy + 1));
	
	return ret;
}

void fragment()
{
	vec4 c = get_blur_color(TEXTURE, UV * vec2(1.0 + u_shrink, 1.0) - vec2(u_shrink * 0.5, 0.0), TEXTURE_PIXEL_SIZE, float(blur_strength));
	COLOR = c * color;
	//COLOR.a = texture(TEXTURE, UV).a * COLOR.a;
	//COLOR.rgb *= COLOR.a;
}
