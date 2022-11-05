varying lowp vec2 text_Coord;

uniform sampler2D texFramebuffer;
uniform lowp float screenAspectRatio;
uniform lowp float sensitivity;

void main() {
  lowp vec4 sum = vec4(0.0);
  for (int x = -4; x <= 4; x++)
    for (int y = -4; y <= 4; y++)
      sum += texture2D(
                     texFramebuffer,
                     vec2(text_Coord.x + float(x) * sensitivity, text_Coord.y + float(y) * sensitivity * screenAspectRatio)
                     ) / 81.0;
  gl_FragColor = sum;
}
