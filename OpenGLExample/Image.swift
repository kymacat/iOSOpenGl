//
//  Image.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import UIKit

enum Image {
  static func getImage(with name: String) -> UIImage {
    guard let image = UIImage(named: name) else {
      assertionFailure("Image \(name) not found")
      return UIImage()
    }

    return image
  }

  static var tiger: UIImage { getImage(with: "tiger") }
  static var duck: UIImage { getImage(with: "duck") }
}
