attribute vec2 position;
attribute vec2 textCoord;

varying lowp vec2 text_Coord;

uniform lowp mat4 model;
uniform lowp float screenAspectRatio;
uniform lowp float textureAspectRatio;

void main() {
  text_Coord = textCoord;
  vec4 transformed = model * vec4(position.x, position.y, 0.0, 1.0);

  float x = transformed.x;
  float y = transformed.y;
  bool isPortrait = screenAspectRatio < 1.0;

  if (isPortrait && textureAspectRatio < screenAspectRatio) {
    isPortrait = false;
  } else if (!isPortrait && textureAspectRatio > screenAspectRatio) {
    isPortrait = true;
  }

  if (isPortrait) {
    float reversedTextureAspectRatio = pow(textureAspectRatio, -1.0);
    y = y * screenAspectRatio * reversedTextureAspectRatio;
  } else {
    float reversedScreenAspectRatio = pow(screenAspectRatio, -1.0);
    x = x * reversedScreenAspectRatio * textureAspectRatio;
  }

  gl_Position = vec4(x, y, transformed.z, 1.0);
}
