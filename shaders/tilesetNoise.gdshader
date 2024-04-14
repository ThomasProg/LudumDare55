shader_type canvas_item;

uniform sampler2D noise : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = mix(COLOR, COLOR * texture(noise, UV), 0.4);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
