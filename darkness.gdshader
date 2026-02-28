shader_type canvas_item;

uniform vec2 light_pos = vec2(0.5, 0.5);
uniform vec2 player_pos = vec2(0.5, 0.5);
uniform float radius : hint_range(0.0, 1.0) = 0.08;
uniform float softness : hint_range(0.0, 1.0) = 0.15;
uniform float player_radius : hint_range(0.0, 1.0) = 0.12;
uniform vec2 aspect_ratio = vec2(1.777, 1.0);
uniform float player_rotation = 0.0;

void fragment() {
	vec2 uv = UV * aspect_ratio;
	vec2 lp = light_pos * aspect_ratio;
	vec2 pp = player_pos * aspect_ratio;
	float c = cos(-player_rotation);
	float s = sin(-player_rotation);
	vec2 diff = uv - pp;
	vec2 rotated = vec2(diff.x * c - diff.y * s, diff.x * s + diff.y * c);
	float player_dist = length(rotated * vec2(0.8, 0.25));
	float dist = distance(uv, lp);
	float lamp_alpha = smoothstep(radius, radius + softness, dist);
	float player_alpha = smoothstep(player_radius, player_radius + 0.06, player_dist);
	float alpha = min(lamp_alpha, player_alpha);
	COLOR = vec4(0.0, 0.05, 0.1, alpha);
}