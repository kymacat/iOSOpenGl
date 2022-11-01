varying lowp vec2 text_Coord;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform lowp float time;

void main() {
  lowp vec4 firstTexColor = texture2D(texture0, text_Coord);
  lowp vec4 secondTexColor = texture2D(texture1, text_Coord);
  gl_FragColor = mix(firstTexColor, secondTexColor, (sin(time) + 1.0) / 2.0);
}
