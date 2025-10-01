shader_type canvas_item;

uniform float scroll_speed : hint_range(0, 2) = 0.08;
uniform float angle_degrees : hint_range(0, 360) = 45.0;

void fragment() {
	float angle_rad = radians(angle_degrees);
 	vec2 direction = vec2(cos(angle_rad), sin(angle_rad));
	
	COLOR = texture(TEXTURE, mod(UV + TIME * direction * scroll_speed, 1.0));
}