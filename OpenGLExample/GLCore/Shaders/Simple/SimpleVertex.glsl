attribute vec2 position;
attribute vec3 color;

varying lowp vec3 frag_Color;

void main() {
  frag_Color = color;
  gl_Position = vec4(position, 0.0, 1.0);
}
