varying lowp vec2 text_Coord;

uniform sampler2D texFramebuffer;
uniform lowp float screenAspectRatio;
uniform lowp float sensitivity;

void main() {
  lowp vec4 top         = texture2D(texFramebuffer, vec2(text_Coord.x, text_Coord.y + sensitivity * screenAspectRatio));
  lowp vec4 bottom      = texture2D(texFramebuffer, vec2(text_Coord.x, text_Coord.y - sensitivity * screenAspectRatio));
  lowp vec4 left        = texture2D(texFramebuffer, vec2(text_Coord.x - sensitivity, text_Coord.y));
  lowp vec4 right       = texture2D(texFramebuffer, vec2(text_Coord.x + sensitivity, text_Coord.y));
  lowp vec4 topLeft     = texture2D(texFramebuffer, vec2(text_Coord.x - sensitivity, text_Coord.y + sensitivity * screenAspectRatio));
  lowp vec4 topRight    = texture2D(texFramebuffer, vec2(text_Coord.x + sensitivity, text_Coord.y + sensitivity * screenAspectRatio));
  lowp vec4 bottomLeft  = texture2D(texFramebuffer, vec2(text_Coord.x - sensitivity, text_Coord.y - sensitivity * screenAspectRatio));
  lowp vec4 bottomRight = texture2D(texFramebuffer, vec2(text_Coord.x + sensitivity, text_Coord.y - sensitivity * screenAspectRatio));
  lowp vec4 sx = -topLeft - 2.0 * left - bottomLeft + topRight   + 2.0 * right  + bottomRight;
  lowp vec4 sy = -topLeft - 2.0 * top  - topRight   + bottomLeft + 2.0 * bottom + bottomRight;
  lowp vec4 sobel = sqrt(sx * sx + sy * sy);
  gl_FragColor = sobel;
}
