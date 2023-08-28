shader_type canvas_item;

uniform sampler2D mirror_texture;
uniform float reflection_amount;

void fragment() {
    // Get the texture coordinates
    vec2 uv = SCREEN_UV;

    // Flip the y-coordinate to create a mirror effect
    uv.y = 1.0 - uv.y;

    // Retrieve the color from the mirror texture
    vec4 mirror_color = texture(mirror_texture, uv);

    // Mix the mirror color with the original color based on reflection_amount
    COLOR = mix(COLOR, mirror_color, reflection_amount);
}
