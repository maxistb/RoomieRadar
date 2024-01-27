//
// Created by Maximillian Stabe on 20.01.24.
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import Foundation

public struct WGSearcher {
  var age: String
  var contactInfo: String
  var gender: String
  var hobbies: String
  let id: String
  var imageString: String
  var name: String
  var ownDescription: String

  public static var shared = WGSearcher(age: "", contactInfo: "", gender: "", hobbies: "", id: "", imageString: "", name: "", ownDescription: "")
}
