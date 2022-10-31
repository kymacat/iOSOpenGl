//
//  GLTextureRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 30.10.2022.
//

import GLKit

class GLTextureRenderer: GLRenderer {
  private var texture: GLTexture

  init(program: GLProgram, mesh: GLMesh, texture: GLTexture) {
    self.texture = texture
    super.init(program: program, mesh: mesh)
  }

  override func setup() {
    super.setup()
    setupTexture()
  }

  private func setupTexture() {
    var textureId: GLuint = 0
    glGenTextures(1, &textureId)
    texture.setup(texture: GLenum(GL_TEXTURE1), id: textureId)
  }

  override func glkViewControllerUpdate(_ controller: GLKViewController) {
    program.prepareToDraw()
    mesh.prepareToDraw()

    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    glUniform1i(glGetUniformLocation(program.glProgram, texture.attribName), GLint(texture.id))

    let model = GLKMatrix4.identity.rotate(rotationZ: texture.rotationAngle)
    model.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderUniform.modelMatrix.rawValue), 1, 0, $0)
    }

    glUniform1f(
      glGetUniformLocation(program.glProgram, GLShaderUniform.textureAspectRatio.rawValue),
      texture.aspectRatio
    )
    glUniform1f(
      glGetUniformLocation(program.glProgram, GLShaderUniform.screenAspectRatio.rawValue),
      GLfloat(controller.view.bounds.width / controller.view.bounds.height)
    )
    glDrawArrays(GLenum(GL_TRIANGLES), 0, mesh.verticesCount)
  }

  override func changeTextures(with images: [UIImage]) {
    guard let image = images.first else { return }
    texture = GLTexture(image: image, attribName: "text")
    setupTexture()
  }
}
