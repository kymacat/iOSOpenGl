varying lowp vec2 text_Coord;

uniform sampler2D texFramebuffer;
uniform highp vec2 texOffset;

void main() {
  highp float kernel[9];
  kernel[0] = 0.00481007202;
  kernel[1] = 0.0286864862;
  kernel[2] = 0.102712765;
  kernel[3] = 0.220796734;
  kernel[4] = 0.284958780;
  kernel[5] = 0.220796734;
  kernel[6] = 0.102712765;
  kernel[7] = 0.0286864862;
  kernel[8] = 0.00481007202;

  highp vec4 sum = vec4(0.0);
  for (int i = -4; i <= 4; i++)
    sum += texture2D(
                     texFramebuffer,
                     text_Coord + float(i) * texOffset
                     ) * kernel[i + 4];
  gl_FragColor = sum;
}
