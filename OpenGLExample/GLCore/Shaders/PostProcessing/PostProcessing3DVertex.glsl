attribute vec2 position;
attribute vec2 textCoord;

varying lowp vec2 text_Coord;

uniform lowp mat4 model;
uniform lowp mat4 view;
uniform lowp mat4 proj;

void main() {
  text_Coord = textCoord;
  gl_Position = proj * view * model * vec4(position, 0.0, 1.0);
}
