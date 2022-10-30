//
//  Renderers.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 10.10.2022.
//

import Foundation

extension GLRenderer {
  static let allRenderers: [GLRendererModel] = [
    GLRendererModel(title: "Points renderer", buildClosure: { pointsRenderer }),
    GLRendererModel(title: "Simple triangle renderer", buildClosure: { simpleTriangleRenderer }),
    GLRendererModel(title: "Simple rectangle renderer", buildClosure: { simpleRectangleRenderer }),
    GLRendererModel(title: "Textures transition renderer", buildClosure: { texturesMixRenderer }),
    GLRendererModel(title: "Texture with water effect renderer", buildClosure: { textureWithWaterEffectRenderer }),
    GLRendererModel(title: "Box with mirror floor renderer", buildClosure: { boxWithMirroringRenderer }),
    GLRendererModel(title: "Box with inverce post processing renderer", buildClosure: { boxWithInvercePostProcessingRenderer }),
    GLRendererModel(title: "Box with grayscale post processing renderer", buildClosure: { boxWithGrayscalePostProcessingRenderer }),
    GLRendererModel(title: "Box with blur post processing renderer", buildClosure: { boxWithBlurPostProcessingRenderer }),
    GLRendererModel(title: "Box with sobel post processing renderer", buildClosure: { boxWithSobelPostProcessingRenderer }),
    GLRendererModel(title: "Box with two pass gaussian blur post processing renderer", buildClosure: { boxWithTwoPassGaussianBlurPostProcessingRenderer }),
    GLRendererModel(title: "Box with mirror renderer", buildClosure: { boxWithPanelRenderer }),
    GLRendererModel(title: "Gravity points renderer", buildClosure: { gravityPointsRenderer }),
  ]


  static var pointsRenderer: GLRenderer {
    GLPointsRenderer(
      program: GLProgram(
        vertexShader: .pointsVertex,
        fragmentShader: .pointsFragment,
        attributes: [.position]
      ),
      mesh: .points
    )
  }

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

  static var gravityPointsRenderer: GLRenderer {
    GLGravityPointsRenderer(
      program: GLProgram(
        vertexShader: .gravityPointsVertex,
        fragmentShader: .gravityPointsFragment,
        attributes: [.position, .velocity, .origPosition],
        feedbackVaryings: [.outPosition, .outVelocity]
      ),
      mesh: .gravityPoints
    )
  }
}

