//
//  GLRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLRenderer: NSObject, GLKViewControllerDelegate {
  let effect: GLEffect
  let mesh: GLMesh

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
    mesh.setupDescriptor()

    glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.indexes.count), GLenum(GL_UNSIGNED_INT), nil)

//    If you want to draw without indexes
//    glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(mesh.vertices.count))

    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
  }
}
