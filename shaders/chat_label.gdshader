shader_type canvas_item;

void fragment() {
    vec4 tex = texture(TEXTURE, UV) * COLOR;

    // If fully transparent → keep it
    if (tex.a < 0.01) {}
    // If it's fully black (the outline) → leave it untouched
    else if (tex.rgb == vec3(0.0)) {

        //return;
    }
	else{
    // Otherwise (white text & AA edges) → force white
    COLOR = vec4(1.0, 1.0, 1.0, 1.0);

	}
}
