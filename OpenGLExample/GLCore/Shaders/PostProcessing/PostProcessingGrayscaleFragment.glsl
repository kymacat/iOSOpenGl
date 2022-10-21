varying lowp vec2 text_Coord;

uniform sampler2D texFramebuffer;

void main() {
  gl_FragColor = texture2D(texFramebuffer, text_Coord);
  lowp float avg = (gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3.0;
  gl_FragColor = vec4(avg, avg, avg, 1.0);
}
