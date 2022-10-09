varying lowp vec2 text_Coord;

uniform sampler2D firstTex;
uniform sampler2D secondTex;
uniform lowp float time;

void main() {
  lowp vec4 firstTexColor = texture2D(firstTex, text_Coord);
  lowp vec4 secondTexColor = texture2D(secondTex, text_Coord);
  gl_FragColor = mix(firstTexColor, secondTexColor, (sin(time) + 1.0) / 2.0);
}
