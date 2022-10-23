varying lowp vec2 text_Coord;

uniform sampler2D texFramebuffer;

void main() {
  gl_FragColor = texture2D(texFramebuffer, text_Coord);
}
