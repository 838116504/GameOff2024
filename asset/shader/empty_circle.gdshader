shader_type canvas_item;

uniform vec2 center_position = vec2(960, 540);
uniform float radius = 50;
uniform float atten_distance = 16;

void fragment()
{
	vec2 curPos = FRAGCOORD.xy;
	float dist = length(curPos - center_position);
	if (dist < radius)
	{
		if (dist < radius - atten_distance)
			discard;
		else
		{
			COLOR.a = (dist - max(radius - atten_distance, 0.0)) / atten_distance;
		}
	}
}
