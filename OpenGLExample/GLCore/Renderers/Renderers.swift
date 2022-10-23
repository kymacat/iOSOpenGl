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
      program: GLProgram(
        vertexShader: .simpleVertex,
        fragmentShader: .simpleFragment,
        attributes: [.position, .color]
      ),
      mesh: .triangle
    )
  }

  static var simpleRectangleRenderer: GLRenderer {
    GLRenderer(
      program: GLProgram(
        vertexShader: .simpleVertex,
        fragmentShader: .simpleFragment,
        attributes: [.position, .color]
      ),
      mesh: .rectangle
    )
  }

  static var texturesMixRenderer: GLRenderer {
    GLObjWithTextureRenderer(
      program: GLProgram(
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
      program: GLProgram(
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
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor
    )
  }

  static var boxWithInvercePostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingInverceFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithGrayscalePostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingGrayscaleFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithBlurPostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingBlurFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithSobelPostProcessingRenderer: GLRenderer {
    GLBoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingSobelFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithTwoPassGaussianBlurPostProcessingRenderer: GLRenderer {
    GLBoxTwoPassGaussianBlurRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingGaussianBlurFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithPanelRenderer: GLRenderer {
    GLBoxWithPanelRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment,
        attributes: [.position, .color]
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessing3DVertex,
        fragmentShader: .postProcessingFragment,
        attributes: [.position, .textureCoordinate]
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }
}

