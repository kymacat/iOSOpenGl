//
//  GLMeshDescriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 15.10.2022.
//

import Foundation

protocol GLMeshDescriptor {
  var stride: Int { get }
  var attrubutes: [GLVertexAttributes] { get }
  func setup()
}
