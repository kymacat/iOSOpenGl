varying lowp vec2 text_Coord;

uniform sampler2D text;

void main() {
  gl_FragColor = texture2D(text, text_Coord);
}
