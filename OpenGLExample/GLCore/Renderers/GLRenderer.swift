//
//  GLRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLRenderer: NSObject, GLKViewControllerDelegate {
  let program: GLProgram
  let mesh: GLMesh

  init(program: GLProgram, mesh: GLMesh) {
    self.program = program
    self.mesh = mesh
  }

  func setup() {
    program.setup()
    mesh.setup()
  }

  func glkViewControllerUpdate(_ controller: GLKViewController) {
    program.prepareToDraw()
    mesh.prepareToDraw()

    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

    glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.indexes.count), GLenum(GL_UNSIGNED_INT), nil)
  }
}
