shader_type canvas_item;

uniform vec2 player_screen_pos = vec2(640.0, 360.0);
uniform float radius = 150.0;
uniform float softness = 80.0;
uniform float darkness = 0.96;

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	// FRAGCOORD origin is bottom-left, flip Y to match screen coords (top-left)
	vec2 frag_pos = vec2(FRAGCOORD.x, screen_size.y - FRAGCOORD.y);
	float dist = distance(frag_pos, player_screen_pos);
	float alpha = smoothstep(radius, radius + softness, dist);
	COLOR = vec4(0.0, 0.0, 0.0, alpha * darkness);
}
