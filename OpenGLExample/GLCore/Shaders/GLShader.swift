//
//  GLShaders.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import Foundation

enum GLShader: String {
  case simpleVertex = "SimpleVertex"
  case simpleFragment = "SimpleFragment"

  case obj3DVertex = "Obj3DVertex"
  case obj3DFragment = "Obj3DFragment"

  case textureVertex = "ObjWithTextureVertex"
  case textureMixFragment = "TextureMixFragment"
  case textureWithWaterEffect = "TextureWithWaterEffectFragment"

  case postProcessingVertex = "PostProcessingVertex"
  case postProcessing3DVertex = "PostProcessing3DVertex"
  case postProcessingFragment = "PostProcessingFragment"
  case postProcessingInverceFragment = "PostProcessingInverceFragment"
  case postProcessingGrayscaleFragment = "PostProcessingGrayscaleFragment"
  case postProcessingBlurFragment = "PostProcessingBlurFragment"
  case postProcessingSobelFragment = "PostProcessingSobelFragment"
  case postProcessingGaussianBlurFragment = "PostProcessingGaussianBlurFragment"
}
