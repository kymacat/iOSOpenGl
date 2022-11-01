//
//  Renderers.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 10.10.2022.
//

import Foundation

extension GLRenderer {
  static var initialRendererModel: GLRendererModel {
    GLRendererModel(title: "Box", buildClosure: { boxWithMirroringRenderer })
  }

  static let allRenderers: [GLRendererModel] = [
    GLRendererModel(title: "Points", buildClosure: { pointsRenderer }),
    GLRendererModel(title: "Simple triangle", buildClosure: { simpleTriangleRenderer }),
    GLRendererModel(title: "Simple rectangle", buildClosure: { simpleRectangleRenderer }),
    GLRendererModel(title: "Textures picker", isImagePickerAvailable: true, imagePickerMaxImages: 1, buildClosure: { textureRenderer }),
    GLRendererModel(title: "Textures transition", isImagePickerAvailable: true, imagePickerMaxImages: 2, buildClosure: { texturesMixRenderer }),
    GLRendererModel(title: "Texture with water effect", isImagePickerAvailable: true, imagePickerMaxImages: 1, buildClosure: { textureWithWaterEffectRenderer }),
    GLRendererModel(title: "Box", buildClosure: { boxWithMirroringRenderer }),
    GLRendererModel(title: "Box with inverce", buildClosure: { boxWithInvercePostProcessingRenderer }),
    GLRendererModel(title: "Box with grayscale", buildClosure: { boxWithGrayscalePostProcessingRenderer }),
    GLRendererModel(title: "Box with blur", buildClosure: { boxWithBlurPostProcessingRenderer }),
    GLRendererModel(title: "Box with sobel", buildClosure: { boxWithSobelPostProcessingRenderer }),
    GLRendererModel(title: "Box with two pass gaussian blur", buildClosure: { boxWithTwoPassGaussianBlurPostProcessingRenderer }),
    GLRendererModel(title: "Box with mirror", buildClosure: { boxWithPanelRenderer }),
    GLRendererModel(title: "Gravity points", buildClosure: { gravityPointsRenderer }),
  ]


  static var pointsRenderer: GLRenderer {
    PointsRenderer(
      program: GLProgram(
        vertexShader: .pointsVertex,
        fragmentShader: .pointsFragment
      ),
      mesh: .points
    )
  }

  static var simpleTriangleRenderer: GLRenderer {
    GLRenderer(
      program: GLProgram(
        vertexShader: .simpleVertex,
        fragmentShader: .simpleFragment
      ),
      mesh: .triangle
    )
  }

  static var simpleRectangleRenderer: GLRenderer {
    GLRenderer(
      program: GLProgram(
        vertexShader: .simpleVertex,
        fragmentShader: .simpleFragment
      ),
      mesh: .rectangle
    )
  }

  static var textureRenderer: GLRenderer {
    TextureRenderer(
      program: GLProgram(
        vertexShader: .textureVertex,
        fragmentShader: .textureFragment
      ),
      mesh: .fullScreenRevercedTexture,
      texture: GLTexture(image: Image.tiger)
    )
  }

  static var texturesMixRenderer: GLRenderer {
    ObjWithTextureRenderer(
      program: GLProgram(
        vertexShader: .objWithTextureVertex,
        fragmentShader: .textureMixFragment
      ),
      mesh: .rectangleWithTexture,
      textures: [
        GLTexture(image: Image.tiger),
        GLTexture(image: Image.duck)
      ]
    )
  }

  static var textureWithWaterEffectRenderer: GLRenderer {
    ObjWithTextureRenderer(
      program: GLProgram(
        vertexShader: .objWithTextureVertex,
        fragmentShader: .textureWithWaterEffect
      ),
      mesh: .rectangleWithTexture,
      textures: [
        GLTexture(image: Image.duck)
      ]
    )
  }

  static var boxWithMirroringRenderer: GLRenderer {
    BoxWithMirroringRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment
      ),
      mesh: .boxWithFloor
    )
  }

  static var boxWithInvercePostProcessingRenderer: GLRenderer {
    BoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingInverceFragment
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithGrayscalePostProcessingRenderer: GLRenderer {
    BoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingGrayscaleFragment
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithBlurPostProcessingRenderer: GLRenderer {
    BoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingBlurFragment
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithSobelPostProcessingRenderer: GLRenderer {
    BoxPostProcessingRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingSobelFragment
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithTwoPassGaussianBlurPostProcessingRenderer: GLRenderer {
    BoxTwoPassGaussianBlurRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessingVertex,
        fragmentShader: .postProcessingGaussianBlurFragment
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var boxWithPanelRenderer: GLRenderer {
    BoxWithPanelRenderer(
      program: GLProgram(
        vertexShader: .obj3DVertex,
        fragmentShader: .obj3DFragment
      ),
      mesh: .boxWithFloor,
      postProcessingProgram: GLProgram(
        vertexShader: .postProcessing3DVertex,
        fragmentShader: .postProcessingFragment
      ),
      postProcessingMesh: .fullScreenTexture
    )
  }

  static var gravityPointsRenderer: GLRenderer {
    GravityPointsRenderer(
      program: GLProgram(
        vertexShader: .gravityPointsVertex,
        fragmentShader: .gravityPointsFragment,
        feedbackVaryings: [.outPosition, .outVelocity]
      ),
      mesh: .gravityPoints
    )
  }
}

