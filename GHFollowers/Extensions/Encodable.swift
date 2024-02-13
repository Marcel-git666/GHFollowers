//
//  Encodable.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 11.02.2024.
//

import Foundation

// https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary
extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError(domain: "encodable as dict", code: 77, userInfo: nil)
    }
    return dictionary
  }
}
