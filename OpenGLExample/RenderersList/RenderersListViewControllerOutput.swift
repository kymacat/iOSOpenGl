//
//  RenderersListViewControllerOutput.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 30.10.2022.
//

import Foundation

protocol RenderersListViewControllerOutput: AnyObject {
  func didSelectRenderer(_ rendererModel: GLRendererModel)
}
