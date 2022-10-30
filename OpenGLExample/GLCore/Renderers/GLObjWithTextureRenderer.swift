//
//  GLTextureRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLObjWithTextureRenderer: GLRenderer {
  private var flipAngle: GLfloat = 0
  private var time: GLfloat = 0
  private let textures: [GLTexture]

  init(program: GLProgram, mesh: GLMesh, textures: [GLTexture]) {
    self.textures = textures
    super.init(program: program, mesh: mesh)
  }

  override func setup() {
    super.setup()

    var textureNames = Array(repeating: GLuint(0), count: textures.count)
    glGenTextures(GLsizei(textures.count), &textureNames)

    var activeTexture = GL_TEXTURE0
    textures.enumerated().forEach {
      activeTexture += 1
      $0.element.setup(texture: GLenum(activeTexture), name: textureNames[$0.offset])
    }
  }

  override func glkViewControllerUpdate(_ controller: GLKViewController) {
    time += 1
    program.prepareToDraw()
    mesh.prepareToDraw()
    drawObject(containerSize: controller.view.bounds.size)
  }

  private func drawObject(containerSize: CGSize) {
    glEnable(GLenum(GL_DEPTH_TEST))
    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))

    textures.forEach { glUniform1i(glGetUniformLocation(program.glProgram, $0.attribName), GLint($0.name)) }

    glUniform1f(glGetUniformLocation(program.glProgram, GLShaderAttribute.time.rawValue), time / 10)

    let model = GLKMatrix4.identity.rotate(rotationX: flipAngle)
    model.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderAttribute.modelMatrix.rawValue), 1, 0, $0)
    }
    flipAngle /= 1.1

    let view = GLKMatrix4(eye: [-1.0, -1.0, 1.0], center: [0.0, 0.0, 0.0], up: [0.0, 0.0, 1.0])
    view.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderAttribute.viewMatrix.rawValue), 1, 0, $0)
    }

    let proj = GLKMatrix4(
      projectionFov: .pi / 2,
      near: 1,
      far: 10,
      aspect: Float(containerSize.width / containerSize.height)
    )
    proj.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderAttribute.projectionMatrix.rawValue), 1, 0, $0)
    }

    glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.indexes.count), GLenum(GL_UNSIGNED_INT), nil)
    glDisable(GLenum(GL_DEPTH_TEST))
  }

  override func touchesEnded(_ touches: Set<UITouch>, in view: UIView) {
    flipAroundX()
  }

  private func flipAroundX() {
    flipAngle += 2 * .pi
  }
}
