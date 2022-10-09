//
//  GLTexture.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLTexture {
  let image: CGImage
  let attribName: String
  let wrapX: GLint
  let wrapY: GLint
  let filter: GLint

  private(set) var texture: GLenum = 0
  private(set) var name: GLuint = 0

  init(
    image: CGImage,
    attribName: String,
    wrapX: GLint = GL_CLAMP_TO_EDGE,
    wrapY: GLint = GL_CLAMP_TO_EDGE,
    filter: GLint = GL_NEAREST
  ) {
    self.image = image
    self.attribName = attribName
    self.wrapX = wrapX
    self.wrapY = wrapY
    self.filter = filter
  }

  deinit {
    glDeleteTextures(1, [name])
  }

  func setup(texture: GLenum, name: GLuint) {
    self.texture = texture
    self.name = name

    guard let colorSpace = image.colorSpace else { return }

    let width = GLsizei(image.width)
    let height = GLsizei(image.height)
    let pixelCount = width * height

    var imageData = Array(repeating: UInt32(0), count: Int(pixelCount))

    let imageContext = CGContext(
      data: &imageData,
      width: Int(width),
      height: Int(height),
      bitsPerComponent: 8,
      bytesPerRow: Int(width * 4),
      space: colorSpace,
      bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue
    )

    imageContext?.draw(image, in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))

    glActiveTexture(texture)
    glBindTexture(GLenum(GL_TEXTURE_2D), name)
    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageData)

    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), filter)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), filter)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), wrapX)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), wrapY)
  }
}
