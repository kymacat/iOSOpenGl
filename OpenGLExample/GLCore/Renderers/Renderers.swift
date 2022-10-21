//
//  Renderers.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 10.10.2022.
//

import Foundation

extension GLRenderer {
  static var simpleTriangleRenderer: GLRenderer {
    GLRenderer(
      shader: GLEffect(
        vertexShader: .simpleVertex,
        fragmentShader: .simpleFragment,
        attributes: [.position, .color]
      ),
      mesh: .triangle
    )
  }

  static var simpleRectangleRenderer: GLRenderer {
    GLRenderer(
      shader: GLEffect(
        vertexShader: .simpleVertex,
        fragmentShader: .simpleFragment,
        attributes: [.position, .color]
      ),
      mesh: .rectangle
    )
  }

  static var texturesMixRenderer: GLRenderer {
    GLObjWithTextureRenderer(
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
  }

  static var textureWithWaterEffectRenderer: GLRenderer {
    GLObjWithTextureRenderer(
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

  static var boxWithMirroringRenderer: GLRenderer {
    GLBoxWithMirroringRenderer(
      shader: GLEffect(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor
    )
  }

  static var boxWithInvercePostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      shader: GLEffect(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingEffect: GLEffect(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingInverceFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithGrayscalePostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      shader: GLEffect(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingEffect: GLEffect(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingGrayscaleFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithBlurPostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      shader: GLEffect(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingEffect: GLEffect(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingBlurFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithSobelPostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      shader: GLEffect(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingEffect: GLEffect(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingSobelFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }
}

