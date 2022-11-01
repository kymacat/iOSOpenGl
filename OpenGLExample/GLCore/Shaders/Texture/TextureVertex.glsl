attribute vec2 position;
attribute vec2 textCoord;

varying lowp vec2 text_Coord;

uniform lowp mat4 model;
uniform bool isPortrait;
uniform lowp float screenAspectRatio;
uniform lowp float textureAspectRatio;

void main() {
  text_Coord = textCoord;
  vec4 transformed = model * vec4(position.x, position.y, 0.0, 1.0);
  float x = transformed.x;
  float y = transformed.y;

  if (isPortrait) {
    y = y * screenAspectRatio * textureAspectRatio;
  } else {
    x = x * screenAspectRatio * textureAspectRatio;
  }

  gl_Position = vec4(x, y, transformed.z, 1.0);
}
