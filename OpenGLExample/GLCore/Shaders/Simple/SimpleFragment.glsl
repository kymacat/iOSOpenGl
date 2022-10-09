varying lowp vec3 frag_Color;

void main() {
  gl_FragColor = vec4(frag_Color, 1.0);
}
