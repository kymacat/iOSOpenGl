varying lowp vec2 text_Coord;

uniform sampler2D texFramebuffer;

void main() {
  gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0) - texture2D(texFramebuffer, text_Coord);
}
