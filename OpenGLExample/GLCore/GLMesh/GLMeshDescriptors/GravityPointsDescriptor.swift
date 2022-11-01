//
//  GravityPointsDescriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 28.10.2022.
//

import GLKit

class GravityPointsDescriptor: GLMeshDescriptor {
  let stride = 6

  var attrubutes: [GLVertexAttributes] = [
    GLVertexAttributes.position,
    GLVertexAttributes.velocity,
    GLVertexAttributes.origPosition
  ]

  func setup() {
    glEnableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.position.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      nil
    )

    glEnableVertexAttribArray(GLVertexAttributes.velocity.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.velocity.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 2 * MemoryLayout<GLfloat>.stride)
    )

    glEnableVertexAttribArray(GLVertexAttributes.origPosition.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.origPosition.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 4 * MemoryLayout<GLfloat>.stride)
    )
  }

  deinit {
    attrubutes.forEach { glDisableVertexAttribArray($0.rawValue) }
  }
}
