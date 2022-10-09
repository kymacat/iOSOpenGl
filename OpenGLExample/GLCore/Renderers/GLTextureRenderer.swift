//
//  GLTextureRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLTextureRenderer: GLRenderer {
  private var time: GLfloat = 0
  private let textures: [GLTexture]

  init(shader: GLEffect, mesh: GLMesh, textures: [GLTexture]) {
    self.textures = textures
    super.init(shader: shader, mesh: mesh)
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

    glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.indexes.count), GLenum(GL_UNSIGNED_INT), nil)

//    If you want to draw without indexes
//    glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(mesh.vertices.count))

    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
  }
}
