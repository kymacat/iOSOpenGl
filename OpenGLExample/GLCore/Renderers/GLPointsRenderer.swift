//
//  GLPointsRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 23.10.2022.
//

import GLKit

class GLPointsRenderer: GLRenderer {
  override func glkViewControllerUpdate(_ controller: GLKViewController) {
    program.prepareToDraw()
    mesh.prepareToDraw()

    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    glDrawArrays(GLenum(GL_POINTS), 0, mesh.verticesCount)
  }
}
