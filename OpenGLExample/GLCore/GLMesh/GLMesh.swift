//
//  GLMesh.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLMesh {
  let vertices: [GLfloat]
  let indexes: [GLuint]
  let descriptor: GLMeshDescriptor

  private var vertexArrayObject: GLuint = 0
  private var vertexBufferObject: GLuint = 0
  private var elementBufferObject: GLuint = 0

  init(
    vertices: [GLfloat],
    indexes: [GLuint],
    descriptor: GLMeshDescriptor
  ) {
    self.vertices = vertices
    self.indexes = indexes
    self.descriptor = descriptor
  }

  deinit {
    glDeleteBuffers(1, &elementBufferObject)
    glDeleteBuffers(1, &vertexBufferObject)
    glDeleteVertexArrays(1, &vertexArrayObject)
  }

  func setup() {
    glGenVertexArrays(1, &vertexArrayObject)
    glBindVertexArray(vertexArrayObject)

    glGenBuffers(1, &vertexBufferObject)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferObject)
    glBufferData(
      GLenum(GL_ARRAY_BUFFER),
      MemoryLayout<GLfloat>.stride * vertices.count,
      vertices,
      GLenum(GL_STATIC_DRAW)
    )

    glGenBuffers(1, &elementBufferObject)
    glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), elementBufferObject)
    glBufferData(
      GLenum(GL_ELEMENT_ARRAY_BUFFER),
      MemoryLayout<GLuint>.stride * indexes.count,
      indexes,
      GLenum(GL_STATIC_DRAW)
    )
  }

  func setupDescriptor() {
    descriptor.setup()
  }
}

extension GLMesh {
  static let triangle = GLMesh(
    vertices: [
//     x    y    r    g    b
      0.0, 0.5, 1.0, 0.0, 0.0,
      0.5, -0.5, 0.0, 1.0, 0.0,
      -0.5, -0.5, 0.0, 0.0, 1.0
    ],
    indexes: [
      0, 1, 2
    ],
    descriptor: Object2DWithColorDescriptor()
  )

  static let rectangle = GLMesh(
    vertices: [
//     x    y    r    g    b
      -0.5, 0.5, 1.0, 0.0, 0.0,
       0.5, 0.5, 0.0, 1.0, 0.0,
       0.5, -0.5, 0.0, 0.0, 1.0,
       -0.5, -0.5, 1.0, 1.0, 1.0
    ],
    indexes: [
      0, 1, 2,
      2, 3, 0
    ],
    descriptor: Object2DWithColorDescriptor()
  )

  static let rectangleWithTexture = GLMesh(
    vertices: [
//      x    y   z   texX  texY
      -0.5, 0.5, 0.0, 0.0, 0.0,
       0.5, 0.5, 0.0, 1.0, 0.0,
       0.5, -0.5, 0.0, 1.0, 1.0,
       -0.5, -0.5, 0.0, 0.0, 1.0
    ],
    indexes: [
      0, 1, 2,
      2, 3, 0
    ],
    descriptor: Object3DWithTextureDescriptor()
  )

  static let boxWithTexture = GLMesh(
    vertices: [
//      x      y      z     texX  texY
      -0.5,   0.5,  -0.5,   0.0, 0.0,
       0.5,   0.5,  -0.5,   1.0, 0.0,
       0.5,   -0.5, -0.5,   1.0, 1.0,
       -0.5,  -0.5, -0.5,   0.0, 1.0,

       -0.5,  0.5,  0.5,    0.0, 0.0,
        0.5,  0.5,  0.5,    1.0, 0.0,
        0.5,  -0.5, 0.5,    1.0, 1.0,
        -0.5, -0.5, 0.5,    0.0, 1.0
    ],
    indexes: [
      // bottom
      0, 1, 2,
      2, 3, 0,

      // sides
      1, 5, 2,
      5, 6, 2,

      1, 5, 0,
      5, 4, 0,

      0, 4, 7,
      7, 3, 0,

      3, 7, 2,
      2, 6, 7,

      //top
      4, 5, 6,
      6, 7, 4,

      //floor
      8, 9, 10,
      8, 10, 11
    ],
    descriptor: Object3DWithTextureDescriptor()
  )
}
