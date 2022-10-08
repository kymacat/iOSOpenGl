//
//  GLRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLRenderer: NSObject, GLKViewControllerDelegate {
  private let effect: GLEffect
  private let mesh: GLMesh

  init(shader: GLEffect, mesh: GLMesh) {
    self.effect = shader
    self.mesh = mesh
  }

  func setup() {
    effect.setup()
    mesh.setup()
  }

  func glkViewControllerUpdate(_ controller: GLKViewController) {
    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

    effect.prepareToDraw()

    glEnableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.position.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(5 * MemoryLayout<GLfloat>.stride),
      nil
    )

    glEnableVertexAttribArray(GLVertexAttributes.color.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.color.rawValue,
      3,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(5 * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 2 * MemoryLayout<GLfloat>.stride)
    )

    glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.indexes.count), GLenum(GL_UNSIGNED_INT), nil)

//    If you want to draw without indexes
//    glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)

    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
  }
}
