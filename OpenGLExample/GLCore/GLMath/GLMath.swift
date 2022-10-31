//
//  GLMath.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 13.10.2022.
//

import GLKit

typealias float2 = SIMD2<Float>
typealias float3 = SIMD3<Float>
typealias float4 = SIMD4<Float>

extension GLKMatrix4 {
  static var identity: Self {
    GLKMatrix4(.init(
      m00: 1, m01: 0, m02: 0, m03: 0,
      m10: 0, m11: 1, m12: 0, m13: 0,
      m20: 0, m21: 0, m22: 1, m23: 0,
      m30: 0, m31: 0, m32: 0, m33: 1
    ))
  }

  // MARK: - View matrix

  init(eye: float3, center: float3, up: float3) {
    let z = normalize(center - eye)
    let x = normalize(cross(up, z))
    let y = cross(z, x)

    let X = float4(x.x, y.x, z.x, 0)
    let Y = float4(x.y, y.y, z.y, 0)
    let Z = float4(x.z, y.z, z.z, 0)
    let W = float4(-dot(x, eye), -dot(y, eye), -dot(z, eye), 1)
    self.init(.init(
      m00: X.x, m01: X.y, m02: X.z, m03: X.w,
      m10: Y.x, m11: Y.y, m12: Y.z, m13: Y.w,
      m20: Z.x, m21: Z.y, m22: Z.z, m23: Z.w,
      m30: W.x, m31: W.y, m32: W.z, m33: W.w
    ))
  }

  // MARK: - Projection matrix

  init(projectionFov fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = true) {
    let y = 1 / tan(fov * 0.5)
    let x = y / aspect
    let z = lhs ? far / (far - near) : far / (near - far)
    let X = float4( x,  0,  0,  0)
    let Y = float4( 0,  y,  0,  0)
    let Z = lhs ? float4( 0,  0,  z, 1) : float4( 0,  0,  z, -1)
    let W = lhs ? float4( 0,  0,  z * -near,  0) : float4( 0,  0,  z * near,  0)
    self.init(.init(
      m00: X.x, m01: X.y, m02: X.z, m03: X.w,
      m10: Y.x, m11: Y.y, m12: Y.z, m13: Y.w,
      m20: Z.x, m21: Z.y, m22: Z.z, m23: Z.w,
      m30: W.x, m31: W.y, m32: W.z, m33: W.w
    ))
  }

  // MARK: - Translate

  func translate(translation: float3) -> Self {
    GLKMatrix4(.init(
      m00:  m00,                  m01: m01,                 m02: m02,                 m03: m03,
      m10:  m10,                  m11: m11,                 m12: m12,                 m13: m13,
      m20:  m20,                  m21: m21,                 m22: m22,                 m23: m23,
      m30:  m30 + translation.x,  m31: m31 + translation.y, m32: m32 + translation.z, m33: m33
    ))
  }

  // MARK: - Rotate

  func rotate(rotationZ angle: Float) -> Self {
    GLKMatrix4(.init(
      m00:  cos(angle), m01: sin(angle), m02: m02, m03: m03,
      m10: -sin(angle), m11: cos(angle), m12: m12, m13: m13,
      m20:  m20,        m21: m21,        m22: m22, m23: m23,
      m30:  m30,        m31: m31,        m32: m32, m33: m33
    ))
  }

  func rotate(rotationX angle: Float) -> Self {
    GLKMatrix4(.init(
      m00:  m00, m01: m01,          m02: m02, m03:   m03,
      m10:  m10, m11: cos(angle),   m12: sin(angle), m13: m13,
      m20:  m20, m21: -sin(angle),  m22: cos(angle), m23: m23,
      m30:  m30, m31: m31,          m32: m32,        m33: m33
    ))
  }

  func rotate(rotationY angle: Float) -> Self {
    GLKMatrix4(.init(
      m00:  cos(angle),   m01: m01, m02: sin(angle), m03: m03,
      m10:  m10,          m11: m11, m12: m12,        m13: m13,
      m20:  -sin(angle),  m21: m21, m22: cos(angle), m23: m23,
      m30:  m30,          m31: m31, m32: m32,        m33: m33
    ))
  }

  // MARK: - Scale

  func scale(scaling: float3) -> Self {
    GLKMatrix4(.init(
      m00:  m00 * scaling.x,  m01: m01,             m02: m02,             m03: m03,
      m10:  m10,              m11: m11 * scaling.y, m12: m12,             m13: m13,
      m20:  m20,              m21: m21,             m22: m22 * scaling.z, m23: m23,
      m30:  m30,              m31: m31,             m32: m32,             m33: m33
    ))
  }
}
