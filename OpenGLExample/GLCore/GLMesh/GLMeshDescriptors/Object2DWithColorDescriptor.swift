//
//  2DObjectWithColorDescriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 15.10.2022.
//

import GLKit

class Object2DWithColorDescriptor: GLMeshDescriptor {
  func setup() {
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
  }

  deinit {
    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glDisableVertexAttribArray(GLVertexAttributes.color.rawValue)
  }
}
