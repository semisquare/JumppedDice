shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.0f);
uniform float forse = 0.0f;
uniform float size = 0.0f;
uniform float thickness = 0.0f;
uniform float strength = 0.0f;

void fragment(){
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) * smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * forse * mask;
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	color.r = texture(SCREEN_TEXTURE, vec2((SCREEN_UV - disp).x + length(scaledUV - center) * strength, (SCREEN_UV - disp).y)).r;
	color.g = texture(SCREEN_TEXTURE, SCREEN_UV - disp).g;
	color.b = texture(SCREEN_TEXTURE, vec2((SCREEN_UV - disp).x - length(scaledUV - center) * strength, (SCREEN_UV - disp).y)).b;
	COLOR = color;
}