//
//  GLTextureRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLTextureRenderer: GLRenderer {
  private var flipAngle: GLfloat = 0
  private var time: GLfloat = 0
  private let textures: [GLTexture]

  init(shader: GLEffect, mesh: GLMesh, textures: [GLTexture]) {
    self.textures = textures
    super.init(shader: shader, mesh: mesh)
  }

  func flipAroundX() {
    flipAngle += 2 * .pi
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
    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

    effect.prepareToDraw()

    glEnableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.position.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(4 * MemoryLayout<GLfloat>.stride),
      nil
    )

    glEnableVertexAttribArray(GLVertexAttributes.textureCoordinate.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.textureCoordinate.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(4 * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 2 * MemoryLayout<GLfloat>.stride)
    )

    textures.forEach { glUniform1i(glGetUniformLocation(effect.glProgram, $0.attribName), GLint($0.name)) }

    time += 1
    glUniform1f(glGetUniformLocation(effect.glProgram, "time"), time / 10)

    var model = GLKMatrix4.identity.rotate(rotationX: flipAngle)
    model.glFloatPointer { glUniformMatrix4fv(glGetUniformLocation(effect.glProgram, "model"), 1, 0, $0) }
    flipAngle /= 1.1

    var view = GLKMatrix4(eye: [-1.2, -1.2, 1.2], center: [0.0, 0.0, 0.0], up: [0.0, 0.0, 1.0])
    view.glFloatPointer { glUniformMatrix4fv(glGetUniformLocation(effect.glProgram, "view"), 1, 0, $0) }

    var proj = GLKMatrix4(
      projectionFov: .pi / 2,
      near: 1,
      far: 10,
      aspect: Float(controller.view.bounds.width / controller.view.bounds.height)
    )
    proj.glFloatPointer { glUniformMatrix4fv(glGetUniformLocation(effect.glProgram, "proj"), 1, 0, $0) }

    glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.indexes.count), GLenum(GL_UNSIGNED_INT), nil)

//    If you want to draw without indexes
//    glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(mesh.vertices.count))

    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
  }
}
