attribute vec2 position;
attribute vec2 textCoord;

varying lowp vec2 text_Coord;

void main() {
  text_Coord = textCoord;
  gl_Position = vec4(position, 0.0, 1.0);
}
