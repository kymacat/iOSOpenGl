//
//  Points2Descriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 23.10.2022.
//

import GLKit

class Points2DDescriptor: GLMeshDescriptor {
  func setup() {
    glEnableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.position.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(2 * MemoryLayout<GLfloat>.stride),
      nil
    )
  }

  deinit {
    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
  }
}
