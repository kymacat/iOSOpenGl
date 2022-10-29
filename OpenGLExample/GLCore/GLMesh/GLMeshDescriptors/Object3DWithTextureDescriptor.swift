//
//  Object2DWithTextureDescriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 15.10.2022.
//

import GLKit

class Object3DWithTextureDescriptor: GLMeshDescriptor {
  let stride = 5

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

    glEnableVertexAttribArray(GLVertexAttributes.textureCoordinate.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.textureCoordinate.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.stride)
    )
  }

  deinit {
    glDisableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glDisableVertexAttribArray(GLVertexAttributes.textureCoordinate.rawValue)
  }
}
