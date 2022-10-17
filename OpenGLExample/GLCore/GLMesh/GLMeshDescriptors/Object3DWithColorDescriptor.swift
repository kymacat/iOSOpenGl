//
//  Object3DWithColorDescriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 17.10.2022.
//

import GLKit

class Object3DWithColorDescriptor: GLMeshDescriptor {
  func setup() {
    glEnableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.position.rawValue,
      3,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(6 * MemoryLayout<GLfloat>.stride),
      nil
    )

    glEnableVertexAttribArray(GLVertexAttributes.color.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.color.rawValue,
      3,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(6 * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.stride)
    )
  }
}