attribute vec2 position;
attribute vec2 velocity;
attribute vec2 origPosition;

varying highp vec2 outPosition;
varying highp vec2 outVelocity;

uniform float speed;
uniform float gravity;
uniform vec2 fingerPosition;

void main() {
  vec2 newVelocity = origPosition - position;

  if (length(fingerPosition - origPosition) < 0.75) {
    vec2 acceleration = gravity * normalize(fingerPosition - position);
    newVelocity = velocity + acceleration * speed;
  }

  if (length(newVelocity) > 1.0)
    newVelocity = normalize(newVelocity);

  vec2 newPosition = position + newVelocity * speed;
  outPosition = newPosition;
  outVelocity = newVelocity;
  gl_Position = vec4(newPosition, 0.0, 1.0);
  gl_PointSize = 10.0;
}
