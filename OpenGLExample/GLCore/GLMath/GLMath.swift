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

  static func *(lhs: GLKMatrix4, rhs: GLKMatrix4) -> GLKMatrix4 {
    let line0: [Float] = [
      lhs.m00 * rhs.m00 + lhs.m01 * rhs.m10 + lhs.m02 * rhs.m20 + lhs.m03 * rhs.m30,
      lhs.m00 * rhs.m01 + lhs.m01 * rhs.m11 + lhs.m02 * rhs.m21 + lhs.m03 * rhs.m31,
      lhs.m00 * rhs.m02 + lhs.m01 * rhs.m12 + lhs.m02 * rhs.m22 + lhs.m03 * rhs.m32,
      lhs.m00 * rhs.m03 + lhs.m01 * rhs.m13 + lhs.m02 * rhs.m23 + lhs.m03 * rhs.m33,
    ]

    let line1: [Float] = [
      lhs.m10 * rhs.m00 + lhs.m11 * rhs.m10 + lhs.m12 * rhs.m20 + lhs.m13 * rhs.m30,
      lhs.m10 * rhs.m01 + lhs.m11 * rhs.m11 + lhs.m12 * rhs.m21 + lhs.m13 * rhs.m31,
      lhs.m10 * rhs.m02 + lhs.m11 * rhs.m12 + lhs.m12 * rhs.m22 + lhs.m13 * rhs.m32,
      lhs.m10 * rhs.m03 + lhs.m11 * rhs.m13 + lhs.m12 * rhs.m23 + lhs.m13 * rhs.m33,
    ]

    let line2: [Float] = [
      lhs.m20 * rhs.m00 + lhs.m21 * rhs.m10 + lhs.m22 * rhs.m20 + lhs.m23 * rhs.m30,
      lhs.m20 * rhs.m01 + lhs.m21 * rhs.m11 + lhs.m22 * rhs.m21 + lhs.m23 * rhs.m31,
      lhs.m20 * rhs.m02 + lhs.m21 * rhs.m12 + lhs.m22 * rhs.m22 + lhs.m23 * rhs.m32,
      lhs.m20 * rhs.m03 + lhs.m21 * rhs.m13 + lhs.m22 * rhs.m23 + lhs.m23 * rhs.m33,
    ]

    let line3: [Float] = [
      lhs.m30 * rhs.m00 + lhs.m31 * rhs.m10 + lhs.m32 * rhs.m20 + lhs.m33 * rhs.m30,
      lhs.m30 * rhs.m01 + lhs.m31 * rhs.m11 + lhs.m32 * rhs.m21 + lhs.m33 * rhs.m31,
      lhs.m30 * rhs.m02 + lhs.m31 * rhs.m12 + lhs.m32 * rhs.m22 + lhs.m33 * rhs.m32,
      lhs.m30 * rhs.m03 + lhs.m31 * rhs.m13 + lhs.m32 * rhs.m23 + lhs.m33 * rhs.m33,
    ]


    return GLKMatrix4(.init(
      m00: line0[0], m01: line0[1], m02: line0[2], m03: line0[3],
      m10: line1[0], m11: line1[1], m12: line1[2], m13: line1[3],
      m20: line2[0], m21: line2[1], m22: line2[2], m23: line2[3],
      m30: line3[0], m31: line3[1], m32: line3[2], m33: line3[3]
    ))
  }

  // MARK: - View matrix

  init(eye: float3, center: float3, up: float3, lhs: Bool = false) {
    let z = lhs ? normalize(center - eye) : normalize(center + eye)
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

  init(projectionFov fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = false) {
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
