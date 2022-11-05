//
//  GLRendererOutput.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 05.11.2022.
//

import Foundation

protocol GLRendererDelegate: AnyObject {
  func bindDrawableFramebuffer()
  func setInitialSensitivitySliderValue(_ value: Float)
}
