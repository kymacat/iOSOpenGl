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

    descriptor.setup()
  }

  func prepareToDraw() {
    glBindVertexArray(vertexArrayObject)
  }
}

extension GLMesh {
  static var triangle: GLMesh {
    GLMesh(
      vertices: [
//       x    y    r    g    b
        0.0, 0.5, 1.0, 0.0, 0.0,
        0.5, -0.5, 0.0, 1.0, 0.0,
        -0.5, -0.5, 0.0, 0.0, 1.0
      ],
      indexes: [
        0, 1, 2
      ],
      descriptor: Object2DWithColorDescriptor()
    )
  }

  static var rectangle: GLMesh {
    GLMesh(
      vertices: [
//        x    y    r    g    b
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
  }

  static var rectangleWithTexture: GLMesh {
    GLMesh(
      vertices: [
//        x    y   z   texX  texY
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
  }

  static var boxWithTexture: GLMesh {
    GLMesh(
      vertices: [
//       x      y      z     texX  texY
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
        6, 7, 4
      ],
      descriptor: Object3DWithTextureDescriptor()
    )
  }

  static var boxWithFloor: GLMesh {
    GLMesh(
      vertices: [
//       Position         Color
        -0.5, -0.5, -0.5, 0.96, 0.79, 0.65,
        0.5, -0.5, -0.5, 0.8, 0.94, 0.9,
        0.5,  0.5, -0.5, 0.28, 0.56, 0.16,
        0.5,  0.5, -0.5, 0.28, 0.56, 0.16,
        -0.5,  0.5, -0.5, 0.6, 0.9, 0.88,
        -0.5, -0.5, -0.5, 0.96, 0.79, 0.65,

        -0.5, -0.5,  0.5, 1.0, 0.86, 0.37,
        0.5, -0.5,  0.5, 0.64, 0.05, 0.85,
        0.5,  0.5,  0.5, 0.55, 0.83, 0.75,
        0.5,  0.5,  0.5, 0.55, 0.83, 0.75,
        -0.5,  0.5,  0.5, 0.74, 0.97, 0.47,
        -0.5, -0.5,  0.5, 1.0, 0.86, 0.37,

        -0.5,  0.5,  0.5, 0.61, 0.48, 0.70,
        -0.5,  0.5, -0.5, 0.83, 0.99, 0.32,
        -0.5, -0.5, -0.5, 0.53, 0.93, 0.22,
        -0.5, -0.5, -0.5, 0.53, 0.93, 0.22,
        -0.5, -0.5,  0.5, 0.33, 0.41, 0.83,
        -0.5,  0.5,  0.5, 0.61, 0.48, 0.70,

        0.5,  0.5,  0.5, 0.84, 0.06, 0.85,
        0.5,  0.5, -0.5, 0.34, 0.36, 0.99,
        0.5, -0.5, -0.5, 0.21, 0.78, 0.1,
        0.5, -0.5, -0.5, 0.21, 0.78, 0.1,
        0.5, -0.5,  0.5, 0.8, 0.22, 0.87,
        0.5,  0.5,  0.5, 0.84, 0.06, 0.85,

        -0.5, -0.5, -0.5, 0.05, 0.58, 0.83,
        0.5, -0.5, -0.5, 0.17, 0.87, 1.0,
        0.5, -0.5,  0.5, 0.38, 0.95, 0.57,
        0.5, -0.5,  0.5, 0.38, 0.95, 0.57,
        -0.5, -0.5,  0.5, 0.12, 0.16, 0.17,
        -0.5, -0.5, -0.5, 0.05, 0.58, 0.83,

        -0.5,  0.5, -0.5, 0.7, 0.27, 0.01,
        0.5,  0.5, -0.5, 0.17, 0.58, 0.21,
        0.5,  0.5,  0.5, 0.22, 0.84, 0.63,
        0.5,  0.5,  0.5, 0.22, 0.84, 0.63,
        -0.5,  0.5,  0.5, 0.1, 0.42, 0.25,
        -0.5,  0.5, -0.5, 0.7, 0.27, 0.01,

        -1.0, -1.0, -0.5, 0.0, 0.0, 0.0,
        1.0, -1.0, -0.5, 0.0, 0.0, 0.0,
        1.0,  1.0, -0.5, 0.0, 0.0, 0.0,
        1.0,  1.0, -0.5, 0.0, 0.0, 0.0,
        -1.0, 1.0, -0.5, 0.0, 0.0, 0.0,
        -1.0, -1.0, -0.5, 0.0, 0.0, 0.0
      ],
      indexes: [],
      descriptor: Object3DWithColorDescriptor()
    )
  }

  static var fullScreenTexture: GLMesh {
    GLMesh(
      vertices: [
        -1.0,  1.0,  0.0, 1.0,
         1.0,  1.0,  1.0, 1.0,
         1.0, -1.0,  1.0, 0.0,

         1.0, -1.0,  1.0, 0.0,
         -1.0, -1.0,  0.0, 0.0,
         -1.0,  1.0,  0.0, 1.0
      ],
      indexes: [],
      descriptor: Object2DWithTextureDescriptor()
    )
  }
}
