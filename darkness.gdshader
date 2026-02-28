shader_type canvas_item;

uniform vec2 light_pos = vec2(0.5, 0.5);  
uniform float radius : hint_range(0.0, 1.0) = 0.2;
uniform float softness : hint_range(0.0, 1.0) = 0.15;

void fragment() {
    float dist = distance(UV, light_pos);
    float alpha = smoothstep(radius, radius + softness, dist);
    COLOR = vec4(0.0, 0.05, 0.1, alpha);
}