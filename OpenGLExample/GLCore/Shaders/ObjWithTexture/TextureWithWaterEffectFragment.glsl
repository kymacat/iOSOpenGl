varying lowp vec2 text_Coord;

uniform sampler2D texture0;
uniform lowp float time;

void main() {
  if (text_Coord.y < 0.5)
    gl_FragColor = texture2D(texture0, text_Coord);
  else
    gl_FragColor = texture2D(texture0,
      vec2(text_Coord.x + sin(text_Coord.y * 60.0 + time) / 30.0, 1.0 - text_Coord.y)
    ) * vec4(0.7, 0.7, 1.0, 1.0);
}
