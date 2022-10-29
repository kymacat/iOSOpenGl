//
//  Object3DWithColorDescriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 17.10.2022.
//

import GLKit

class Object3DWithColorDescriptor: GLMeshDescriptor {
  let stride = 6

  func setup() {
    glEnableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.position.rawValue,
      3,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      nil
    )

    glEnableVertexAttribArray(GLVertexAttributes.color.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.color.rawValue,
      3,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.stride)
    )
  }

  deinit {
    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glDisableVertexAttribArray(GLVertexAttributes.color.rawValue)
  }
}
