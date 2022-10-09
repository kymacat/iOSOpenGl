//
//  Renderers.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 10.10.2022.
//

import Foundation

extension GLRenderer {
  static let simpleTriangleRenderer = GLRenderer(
    shader: GLEffect(
      vertexShader: .simpleVertex,
      fragmentShader: .simpleFragment,
      attributes: [.position, .color]
    ),
    mesh: .triangle
  )

  static let simpleRectangleRenderer = GLRenderer(
    shader: GLEffect(
      vertexShader: .simpleVertex,
      fragmentShader: .simpleFragment,
      attributes: [.position, .color]
    ),
    mesh: .rectangle
  )

  static let texturesMixRenderer = GLTextureRenderer(
    shader: GLEffect(
      vertexShader: .textureVertex,
      fragmentShader: .textureMixFragment,
      attributes: [.position, .textureCoordinate]
    ),
    mesh: .rectangleWithTexture,
    textures: [
      GLTexture(image: Image.tiger.cgImage!, attribName: "firstTex"),
      GLTexture(image: Image.duck.cgImage!, attribName: "secondTex")
    ]
  )

  static let textureWithWaterEffectRenderer = GLTextureRenderer(
    shader: GLEffect(
      vertexShader: .textureVertex,
      fragmentShader: .textureWithWaterEffect,
      attributes: [.position, .textureCoordinate]
    ),
    mesh: .rectangleWithTexture,
    textures: [
      GLTexture(image: Image.duck.cgImage!, attribName: "tex")
    ]
  )
}
