attribute vec3 position;
attribute vec3 color;

uniform lowp vec3 overrideColor;
uniform lowp mat4 model;
uniform lowp mat4 view;
uniform lowp mat4 proj;

varying lowp vec3 frag_Color;

void main() {
  frag_Color = overrideColor * color;
  gl_Position = proj * view * model * vec4(position, 1.0);
}
