shader_type canvas_item;

uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float density: hint_range(0.0, 1.0) = 0.25;
uniform vec2 speed = vec2(0.000000001, 0.000000005);

void fragment() {
	vec2 uv = UV + speed + TIME;
	
	float noise = texture(noise_texture, uv).r;
	
	float fog = noise * 2.0 - 1.0;
	
	COLOR.a *= fog * density;
}
