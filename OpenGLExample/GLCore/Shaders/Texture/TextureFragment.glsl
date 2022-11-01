varying lowp vec2 text_Coord;

uniform sampler2D texture0;

void main() {
  gl_FragColor = texture2D(texture0, text_Coord);
}
