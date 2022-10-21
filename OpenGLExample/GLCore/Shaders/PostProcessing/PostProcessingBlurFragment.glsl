varying lowp vec2 text_Coord;

uniform sampler2D texFramebuffer;

const lowp float blurSizeH = 1.0 / 500.0;
const lowp float blurSizeV = 1.0 / 500.0;

void main() {
  lowp vec4 sum = vec4(0.0);
  for (int x = -4; x <= 4; x++)
    for (int y = -4; y <= 4; y++)
      sum += texture2D(
                     texFramebuffer,
                     vec2(text_Coord.x + float(x) * blurSizeH, text_Coord.y + float(y) * blurSizeV)
                     ) / 81.0;
  gl_FragColor = sum;
}
